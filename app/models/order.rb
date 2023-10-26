# frozen_string_literal: true

class Order < ApplicationRecord
  include Concerns::Core
  
  attr_reader :order_update_publisher

  has_many :order_items
  has_many :items, through: :order_items

  state_machine do
    event :init do
      transition new: :waiting_for_payment
    end

    event :payment_accepted do
      transition waiting_for_payment: :waiting_for_the_assembly
    end

    event :start_assembly do
      transition waiting_for_the_assembly: :assembling
    end

    event :finish_assembly do
      transition assembling: :waiting_for_the_courier
    end

    event :start_delivery do
      transition waiting_for_the_courier: :delivering
    end

    event :finish_delivery do
      transition delivering: :delivered
    end
  end
end
