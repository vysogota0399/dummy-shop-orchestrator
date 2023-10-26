# frozen_string_literal: true

require_relative('base_contract')

class OrderContract < BaseContract
  params do
    required(:customer_id).value(:integer)
    required(:customer_email).value(:string)
    required(:address).value(:string)
    required(:front_door).value(:string)
    required(:floor).value(:string)
    required(:intercom).value(:string)
    required(:item_ids).value(:array)
  end
end