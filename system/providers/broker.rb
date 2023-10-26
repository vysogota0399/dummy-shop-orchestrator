# frozen_string_literal: true

Orchestrator.register_provider(:broker) do
  prepare do
    provider_config = Orchestrator.config_for('bunny')[Orchestrator.env]
    provider_config.merge(logger: Logger.new("#{Orchestrator.config.log_dir}/broker.log"))
    register(:broker_connection, Bunny.new(provider_config))
  end

  start do
    container[:broker_connection].start
  end

  stop do
    container[:broker_connection].stop
  end
end
