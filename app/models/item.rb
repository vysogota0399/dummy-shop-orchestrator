# frozen_string_literal: true

class Item < ApplicationRecord
  enum :kind, [:alcohol, :vegetables, :fruit, :nuts, :sweets, :milk, :cheese, :eggs,
               :herbal_products, :meat, :fowl, :sausage, :delicacies, :fish, :seafood, :caviar]

  has_many :order_items
  has_many :orders, through: :order_items

  belongs_to :provider

  has_many :item_reviews, dependent: :destroy

  def cost_rub
    cost_cops.to_f / 100.round(2)
  end

  def image_path
    "#{kind}.jpeg"
  end
end
