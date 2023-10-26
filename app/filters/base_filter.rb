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

    predicate = {}
    negative_predicate = {}
    params[:filter].each do |k, v|
      case v
      when Array
        v.each do |v_element|
          v_element.to_s.include?('not_') ? add(negative_predicate, k, v_element.gsub('not_', '')) : add(predicate, k, v_element)
        end
      else
        v.to_s.include?('not_') ? add(negative_predicate, k, v.gsub('not_', '')) : add(predicate, k, v)
      end
    end
    scope.where(predicate).where.not(negative_predicate)
  end

  def apply_order(scope)
    return scope unless params.key?(:order)

    order_by = params[:order].map { |k,v| "#{k} #{v}" }.join(',')
    scope.order(order_by)
  end

  def add(target, key, value)
    if target.key?(key)
      target[key] << value
    else
      target[key] = [value]
    end
  end
end
