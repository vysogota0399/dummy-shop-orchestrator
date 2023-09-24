# frozen_string_literal: true

require_relative 'base_filter'

class ItemsFilter < BaseFilter
  def init_scope
    params.fetch(:scope, Item)
  end
end
