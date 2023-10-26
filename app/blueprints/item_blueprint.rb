# frozen_string_literal: true

class ItemBlueprint < Blueprinter::Base
  fields :id, :kind, :cost_cops, :weight, :remainder, :title, :description
end
