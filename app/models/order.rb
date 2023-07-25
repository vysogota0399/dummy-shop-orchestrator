# frozen_string_literal: true

class Order < ApplicationRecord
  include Concerns::Base
  # attr_accessor :signal_params

  has_many :order_items
  has_many :items, through: :order_items

  state_machine do
    event :start_assembly do
      transition new: :assembling
    end

    event :finish_assembly do
      transition assembling: :waiting_for_the_courier
    end
    before_transition assembling: :waiting_for_the_courier do |order, _transition|
      # TODO: OrderTransitions::FinishAssembly(order)
    end

    event :start_delivery do
      transition waiting_for_the_courier: :delivering
    end
    before_transition waiting_for_the_courier: :delivering do |order, _transition|
      # TODO: OrderTransitions::StartDelivery(order)
    end

    event :finish_delivery do
      transition delivering: :delivered
    end
    before_transition delivering: :delivered do |order, _transition|
      # TODO: OrderTransitions::FinishDelivery(order)
    end
  end
end
