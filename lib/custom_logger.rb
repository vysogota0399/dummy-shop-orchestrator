# frozen_string_literal: true

class CustomLogger
  def initialize(path)
    dir = File.dirname(path)
    @logger = Dry.Logger(path, template: '[%<time>s][%<severity>s] %<message>s')
                 .add_backend(stream: "#{dir}/http.log", log_if: ->(entry) { entry.key?(:http) })
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

  def error(message, **args)
    @logger.error log_message(message), **args
  end

  def level=(_severity); end

  private

  def log_message(message)
    "[#{Thread.current[:request_id]}] #{message}"
  end
end
