# frozen_string_literal: true

class ItemFinder
  attr_reader :filter, :kind, :sort_by, :sort_direction, :id

  SORT_DIRECTION = %w[desc asc]
  SORT_BY = %w[cost_cops]
  SELECT_OPTIONS = Item.kinds.merge('all' => 'all')

  def call(filter)
    @filter = filter
    @kind = filter[:kind]
    @sort_by = filter.fetch(:sort_by, 'created_at')
    @sort_direction = filter.fetch(:sort_direction, 'desc')
    @id = filter.fetch(:id, [])
    build_query
  end

  def meta
    {
      sort_direction: SORT_DIRECTION,
      sort_by: SORT_BY,
      select_options: SELECT_OPTIONS
    }
  end

  private

  def build_query
    return ordered(Item) if filter.blank? || kind.presence == 'all'

    return ordered(Item.where(id: id)) if id.any?

    items = kind.present? ? Item.where(kind: kind) : Item
    ordered(items)
  end

  def ordered(query)
    query.order("#{sort_by} #{sort_direction}")
  end
end
