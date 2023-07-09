# frozen_string_literal: true

class ItemReview < ApplicationRecord
  belongs_to :item, -> { includes :provider }
end