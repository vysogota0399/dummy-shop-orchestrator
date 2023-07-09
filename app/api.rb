# frozen_string_literal: true

require 'sinatra/custom_logger'
require 'sinatra/namespace'
require 'sinatra/json'

class Api < Sinatra::Application
  include Pagy::Backend
  include Import['item_finder']

  helpers Sinatra::CustomLogger
  helpers do
    def add_pagination(query)
      pagination_meta, items = pagy(query)
      {
        pagination: pagination_meta.vars.slice(:count, :page),
        items: items
      }
    end
  end

  set :logger, Orchestrator.logger
  set :show_exceptions, :after_handler

  namespace '/api/v1' do
    error 500 do
      response = { error: 'internal server error' }
      logger.fatal env['sinatra.error'].message, http: true
      json response
    end

    before do
      Thread.current[:request_id] = SecureRandom.hex(16)
      logger.info("Processing request #{request.request_method} #{request.path} from #{request.ip}", http: true)

      case request.request_method
      when 'POST', 'PUT'
        request.body.rewind
        @json_params = JSON.parse(request.body.read).with_indifferent_access
        logger.info("Request params: #{@json_params}", http: true)
      end

      logger.info("Request params: #{params}", http: true)
    end

    after do
      logger.info("Request finished with status: #{response.status}, response body: #{response.body}", http: true)
    end

    get do
      json version: '0.0.1'
    end

    namespace '/items' do
      get do
        with_meta = params.delete(:with_meta)
        response = add_pagination(item_finder.call(params))
        response[:meta] = item_finder.meta if with_meta.presence == 'true'
        json response
      end
    end

    namespace '/orders' do
      post do
        
      end
    end
  end
end
