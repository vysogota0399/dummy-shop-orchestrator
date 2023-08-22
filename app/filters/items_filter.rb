# frozen_string_literal: true

require_relative 'base_filter'

class ItemsFilter < BaseFilter
  private

  def init_scope
    @scope = params.fetch(:scope, Item)
  end
end
