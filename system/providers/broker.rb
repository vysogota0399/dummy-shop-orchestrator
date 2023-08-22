# frozen_string_literal: true

Orchestrator.register_provider(:broker) do
  prepare do
    broker_config = 
      -> (env) do
        config_path = File.join('config', 'bunny.yml')
        file_data = File.read(config_path)
        parsed_data = ERB.new(file_data).result
        config = YAML.safe_load(parsed_data, aliases: true).with_indifferent_access[env]
        config.merge(logger: Logger.new("#{Orchestrator.config.log_dir}/broker.log"))
      end

    conn = Bunny.new(broker_config.call(Orchestrator.env))
    register(:broker_connection, conn)
  end

  start do
    container[:broker_connection].start
  end

  stop do
    container[:broker_connection].stop
  end
end
