# frozen_string_literal: true

class OrderSerializer
  include JSONAPI::Serializer

  attributes :state, :assembler_id, :courier_id, :cost_cops

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