# frozen_string_literal: true

class Provider < ApplicationRecord
  has_many :items, dependent: :destroy
end
