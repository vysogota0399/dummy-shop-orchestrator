# frozen_string_literal: true

class OrderBlueprint < Blueprinter::Base
  fields :id, :state, :assembler_id, :courier_id, :cost_cops, :created_at
  field :error, if: ->(_field_name, order, _options) { order.damaged? }

  field :client do |order, _options|
    {
      customer_id: order.customer_id,
      customer_email: order.customer_email,
      address: order.address,
      front_door: order.front_door,
      floor: order.floor,
      intercom: order.intercom
    }
  end

  field :items do |_order, _options|
    []
  end

  view :extended do
    association :items, blueprint: ItemBlueprint, default: []
  end
end
