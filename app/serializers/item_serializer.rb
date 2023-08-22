# frozen_string_literal: true

class ItemSerializer
  include JSONAPI::Serializer

  attributes :id, :kind, :cost_cops, :weight, :remainder, :title, :description
end