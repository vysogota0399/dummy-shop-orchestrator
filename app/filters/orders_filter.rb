# frozen_string_literal: true

# frozen_string_literal: true

require_relative 'base_filter'

class OrdersFilter < BaseFilter
  def init_scope(scope)
    @scope = params.fetch(:scope, Order)
  end
end
