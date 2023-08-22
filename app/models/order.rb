# frozen_string_literal: true

class Order < ApplicationRecord
  include Concerns::Core
  
  attr_reader :order_update_publisher

  has_many :order_items
  has_many :items, through: :order_items

  state_machine do
    event :prepare do
      transition new: :waiting_for_the_assembly
    end
    before_transition new: :waiting_for_the_assembly do |order, _transition|
      order.item_ids = order.signal_params[:item_ids]
    end

    event :start_assembly do
      transition waiting_for_the_assembly: :assembling
    end
    after_transition new: :assembling do |order, _transition|

    end

    event :finish_assembly do
      transition assembling: :waiting_for_the_courier
    end
    after_transition assembling: :waiting_for_the_courier do |order, _transition|
      # TODO: OrderTransitions::FinishAssembly(order)
    end

    event :start_delivery do
      transition waiting_for_the_courier: :delivering
    end
    after_transition waiting_for_the_courier: :delivering do |order, _transition|
      # TODO: OrderTransitions::StartDelivery(order)
    end

    event :finish_delivery do
      transition delivering: :delivered
    end
    after_transition delivering: :delivered do |order, _transition|
      # TODO: OrderTransitions::FinishDelivery(order)
    end
  end
end
