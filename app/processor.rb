# frozen_string_literal: true

class Processor
  attr_reader :order

  def initialize(args)
    case args
    when Integer, String
      @order = Order.find(args)
    when Hash
      @order = Order.new(args)
    else
      raise Sinatra::BadRequest, { order: { attributes: :blank } }.to_json
    end
  rescue ActiveRecord::RecordNotFound
    raise Sinatra::NotFound
  end

  def send_signal(signal, params = {})
    Orchestrator.logger.info("Processing signal #{signal} for order##{order.id} with params: #{params}")
    order.send(signal, params)
  rescue ActiveRecord::RecordInvalid
    raise Sinatra::BadRequest, { order: order.errors }.to_json
  rescue StandardError => e
    log_error(e)
    order.terminate(error: e)
  end

  private

  def log_error(error)
    message = error.message
    backtrace = error.backtrace
    Orchestrator.logger.fatal("#{message}\n#{backtrace.join('\n')}", orch: true)
  end
end
