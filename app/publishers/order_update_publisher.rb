# frozen_string_literal: true

class OrderUpdatePublisher
  include Import['broker_connection']
  attr_reader :data

  PORTAL_QUEUE = 'portal.order.update'

  def call(data)
    @data = data
    initilize_queues
    exchange.publish(*message)
  end

  private

  def message
    now = Time.current
    [
      data,
      {
        routing_key: 'order.update',
        headers: {
          time: now
        },
        content_type: 'application/json',
        timestamp: now.to_i
      }
    ]
  end

  def ch
    @ch ||= broker_connection.create_channel
  end

  def exchange
    @exchange ||= Bunny::Exchange.new(ch, :direct, 'order.update')
  end

  def initilize_queues
    ch.queue(PORTAL_QUEUE, auto_delete: true).bind(exchange, routing_key: 'order.update')
  end
end
