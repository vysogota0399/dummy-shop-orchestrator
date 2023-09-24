# frozen_string_literal: true

class BaseFilter
  attr_reader :params

  def call(params = {})
    @params = params
    init_scope
      .then { |scope| apply_find(scope) }
      .then { |scope| apply_filter(scope) }
      .then { |scope| apply_order(scope) }
      .then(&:all)
  end

  private

  def init_scope
    raise 'Not implemented'
  end

  def apply_find(scope)
    return scope unless params.key?(:id)

    scope.where(id: params[:id])
  end

  def apply_filter(scope)
    return scope unless params.key?(:filter)

    scope.where(params[:filter])
  end

  def apply_order(scope)
    return scope unless params.key?(:order)

    order_by = params[:order].map { |k,v| "#{k} #{v}" }.join(',')
    scope.order(order_by)
  end
end
