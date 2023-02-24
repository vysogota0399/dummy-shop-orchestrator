# frozen_string_literal: true

require 'sinatra/custom_logger'

class Api < Sinatra::Application
  helpers Sinatra::CustomLogger

  set :logger, Orchestrator.logger

  namespace '/api/v1' do
    before do
      Thread.current[:request_id] = SecureRandom.hex(13)
      logger.info("Processing request [#{request.request_method}] #{request.path} from #{request.ip}")
      logger.info("Request params: #{params}")
    end

    after do
      logger.info("Request finished with status: #{response.status}, response body: #{response.body}")
    end

    get do
      json version: '0.0.1'
    end
  end
end
