# frozen_string_literal: true

class OrderSerializer
  include JSONAPI::Serializer

  attributes :id, :state, :assembler_id, :courier_id, :cost_cops
  attribute :error, if: ->(order) { order.damaged? }

  attribute :client do |object|
    {
      customer_id: object.customer_id,
      customer_email: object.customer_email,
      address: object.address,
      front_door: object.front_door,
      floor: object.floor,
      intercom: object.intercom,
    }
  end
end