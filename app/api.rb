# frozen_string_literal: true

require 'sinatra/custom_logger'
require 'sinatra/namespace'
require 'sinatra/json'

class Api < Sinatra::Application
  include Pagy::Backend
  include Import['orders_filter', 'items_filter']

  helpers Sinatra::CustomLogger
  helpers do
    def with_pagination(scope)
      pagination_meta, scope = pagy(scope)
      {
        meta: pagination_meta.vars.slice(:count, :page, :items),
        scope: scope,
      }
    end

    def render_json_collection(scope)
      paginated = with_pagination(scope)
      serialized_scope = with_serializer(paginated.delete(:scope))
      
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

    error 400 do
      error = env['sinatra.error'].message
      response = { error: JSON.parse(error) }
      json response
    end

    before do
      Thread.current[:request_id] = SecureRandom.hex(16)
      logger.info("Request #{request.request_method} #{request.path} from #{request.ip}", http: true)
      if request.content_type == "application/json" && %w[POST PUT].include?(request.request_method)
        request.body.rewind
        body = JSON.parse(request.body.read.presence || '{}').with_indifferent_access
        @params = body.merge(params.presence || {})
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
        def with_serializer(scope, opts = {})
          ItemSerializer.new(scope, params: opts).serializable_hash
        end
      end

      post '/filter' do
        render_json_collection items_filter.call(params)
      end
    end

    namespace '/orders' do
      helpers do
        def with_serializer(scope, opts = {})
          OrderSerializer.new(scope, params: opts).serializable_hash
        end
      end
      post do
        processor = Processor.new(params.delete(:order))
        processor.send_signal(:validate!)
        processor.send_signal(:prepare, params)
        json with_serializer(processor.order)
      end

      post '/validate' do
        processor = Processor.new(params.delete(:order))
        processor.send_signal(:validate!)
      end

      get '/:id' do
        json with_serializer(Processor.new(params[:id]).order, with_items: true)
      end
    end
  end
end
