# frozen_string_literal: true

class CustomLogger
  ERROR = 'error'
  DEBUG = 'debug'
  INFO  = 'info'

  def initialize(path)
    dir = File.dirname(path)
    level = Orchestrator.config.log_level
    @logger = Dry.Logger(path, template: '[%<time>s][%<severity>s] %<message>s', level: level)
                 .add_backend(stream: "#{dir}/http.log", log_if: ->(entry) { entry.key?(:http) })
                 .add_backend(stream: "#{dir}/orchestrator.log", log_if: ->(entry) { entry.key?(:orch) })
  end

  def info(message, **args)
    @logger.info log_message(message), **args
  end

  def debug(message, **args)
    @logger.debug log_message(message), **args
  end

  def warn(message, **args)
    @logger.warn log_message(message), **args
  end

  def fatal(message, **args)
    @logger.fatal log_message(message), **args
  end

  def level=(_severity); end

  private

  def log_message(message)
    "[#{Thread.current[:request_id]}] #{message}"
  end
end
