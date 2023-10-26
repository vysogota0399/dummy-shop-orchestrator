# frozen_string_literal: true

class OrderUpdatePublisher
  include Dry::Configurable

  attr_reader :broker_connection

  setting :exchange_name, reader: true
  setting :routing_keys, reader: true 

  def initialize
    @broker_connection = Orchestrator['broker_connection']
    configure do |instance_config|
      instance_config.exchange_name = Orchestrator.config.order_update_publisher_config['exchange_name']
      instance_config.routing_keys = Orchestrator.config.order_update_publisher_config['routing_keys']
    end
  end

  def call(data)
    with_channel do |channel|
      each_routing_key do |rk|
        payload = message(data, rk)
        exchange_for(channel).publish(*payload)
      end
    end
  end

  private

  def message(data, routing_key)
    [
      data,
      {
        headers: {
          time: current_time
        },
        content_type: 'application/json',
        timestamp: current_time.to_i,
        message_id: Thread.current[:request_id],
        routing_key: routing_key 
      }
    ]
  end

  def each_routing_key
    routing_keys.each do |rk| 
      yield rk
    end
  end

  def with_channel
    ch = broker_connection.channel
    yield ch
    ch.close
  end

  def exchange_for(channel)
    channel.topic(exchange_name)
  end

  def current_time
    @current_time ||= Time.current
  end
end
