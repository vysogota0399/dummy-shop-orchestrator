# frozen_string_literal: true

require 'sinatra/custom_logger'

class Api < Sinatra::Application
  include Import['api_logger']

  namespace '/api/v1' do
    before do
      Thread.current[:request_id] = SecureRandom.hex(13)
      api_logger.info "Request params: #{params}"
    end

    get do
      json version: '0.0.1'
    end
  end
end
