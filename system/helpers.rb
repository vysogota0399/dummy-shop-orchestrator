# frozen_string_literal: true

module Helpers
  def config_for(target)
    config_path = File.join('config', "#{target}.yml")
    file_data = File.read(config_path)
    parsed_data = ERB.new(file_data).result
    config = YAML.safe_load(parsed_data, aliases: true).with_indifferent_access
  end
end