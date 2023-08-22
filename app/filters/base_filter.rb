# frozen_string_literal: true

class BaseFilter
  attr_reader :params, :scope

  def call(params = {})
    @params = params
    init_scope
    apply_find
    apply_filter
    apply_order
    scope.all
  end

  private

  def init_scope
    raise 'Not implemented'
  end

  def apply_find
    return unless params.key?(:id)

    @scope = scope.where(id: params[:id])
  end

  def apply_filter
    return unless params.key?(:filter)

    @scope = scope.where(params[:filter])
  end

  def apply_order
    return unless params.key?(:order)

    order_by = params[:order].map { |k,v| "#{k} #{v}" }.join(',')
    @scope = scope.order(order_by)
  end
end
