# frozen_string_literal: true

class MyLogger
  def initialize(log_level = :info)
    @logger = Logger.new('logs/application.log', 'daily', level: log_level)
  end

  def info(message)
    @logger.info(message)
  end

  def debug(message)
    @logger.debug(message)
  end
end
