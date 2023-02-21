# frozen_string_literal: true

require 'logger'

class APILogger
  FILE_NAME = 'api.log'

  def initialize(log_level = :info)
    @logger = Logger.new("logs/#{FILE_NAME}", 'daily', level: log_level)
  end

  def info(message)
    @logger.info(message)
  end

  def debug(message)
    @logger.debug(message)
  end
end
