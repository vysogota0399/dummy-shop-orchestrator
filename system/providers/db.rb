# frozen_string_literal: true

Orchestrator.register_provider(:db) do
  prepare do
    require 'active_record'
    config_path = File.join('config', 'database.yml')
    file_data = File.read(config_path)
    parsed_data = ERB.new(file_data).result

    ActiveRecord::Base.configurations = YAML.safe_load(parsed_data, aliases: true)
  end

  start do
    ActiveRecord::Base.establish_connection(Orchestrator.env.to_sym)
    register(:db, ActiveRecord::Base)
  end

  stop {}
end
