# frozen_string_literal: true

require 'sinatra/custom_logger'
require 'sinatra/namespace'
require 'sinatra/json'

class Api < Sinatra::Application
  class BadReqest < StandardError; end

  include Pagy::Backend
  include Import['orders_filter', 'items_filter', 'order_contract']

  helpers Sinatra::CustomLogger
  helpers do
    def with_pagination(scope)
      pagination_meta, scope = pagy(scope)
      {
        meta: pagination_meta.vars.slice(:count, :page, :items),
        scope: scope
      }
    end

    def render_json_collection(scope, blueprint_options = {})
      paginated = with_pagination(scope)
      serialized_scope = with_blueprint(paginated.delete(:scope), blueprint_options)

      json serialized_scope.merge(paginated)
    end
  end

  set :logger, Orchestrator.logger
  set :show_exceptions, :after_handler

  namespace '/api/v1' do
    error 500 do
      response = { error: 'internal server error' }
      error_message = "#{env['sinatra.error'].message}\n#{env['sinatra.error'].backtrace.take(5).join("\n")}"
      logger.fatal error_message, http: true
      json response
    end

    error 404 do
      response = { error: 'not_found' }
      json response
    end

    error BadReqest do
      error = env['sinatra.error'].message
      response = { errors: JSON.parse(error) }
      [400, json(response)]
    end

    before do
      Thread.current[:request_id] = headers.fetch('HTTP_X-Request-Id', SecureRandom.hex(16))
      logger.info("Request #{request.request_method} #{request.path} from #{request.ip}", http: true)
      if %w[application/json application/x-www-form-urlencoded].include?(request.content_type) && %w[POST PUT DELETE].include?(request.request_method)
        request.body.rewind
        body = JSON.parse(request.body.read.presence || '{}').with_indifferent_access
        @params = body.merge(params[:id].presence || {})
      end
      logger.info("Request params: #{params}", http: true)
    end

    after do
      logger.info("Response #{response.status} #{response.body}", http: true)
    end

    get do
      json version: '0.0.1'
    end

    namespace '/items' do
      helpers do
        def with_blueprint(scope, opts = {})
          ItemBlueprint.render_as_hash(scope, { root: :data }.merge(opts))
        end
      end

      post '/filter' do
        render_json_collection items_filter.call(params)
      end

      get '/categories' do
        json data: Item.select(:kind).distinct.pluck(:kind)
      end
    end

    namespace '/orders' do
      helpers do
        def with_blueprint(scope, opts = {})
          OrderBlueprint.render_as_hash(scope, { root: :data }.merge(opts))
        end
      end
      post do
        order_params = params.delete(:order)
        contract = order_contract.call(order_params)
        raise BadReqest.new(contract.errors.to_h.to_json) if contract.errors.present?

        processor = Processor.new(order_params)
        processor.send_signal(:init)
        json with_blueprint(processor.order)
      end

      post '/filter' do
        render_json_collection orders_filter.call(params), view: :extended
      end

      post '/validate' do
        order_params = params.delete(:order)
        result = order_contract.call(order_params)
        return json(data: {}) if result.errors.blank?

        raise BadReqest.new(result.errors.to_h.to_json)
      end

      get '/:id' do
        json with_blueprint(Processor.new(params[:id]).order, view: :extended)
      end
    end
  end
end
