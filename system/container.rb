# frozen_string_literal: true

require 'lib/custom_logger'
require 'system/helpers'

class Orchestrator < Dry::System::Container
  extend Helpers

  use :env, inferrer: -> { ENV.fetch('APP_ENV', :development).to_sym }
  use :logging

  # logger
  setting :log_dir, default: 'log'
  setting :logger_class, default: ::CustomLogger
  setting :log_level, default: ENV.fetch('log_level', 'debug')
  setting :order_update_publisher_config, default: config_for('order_update_publisher')  

  configure do |config|
    config.name = :orchestrator
    config.root = '.'
    config.component_dirs.add 'app' do |dir|
      dir.namespaces.add 'filters', key: nil, const: nil
      dir.namespaces.add 'publishers', key: nil, const: nil
      dir.namespaces.add 'contracts', key: nil, const: nil
    end
  end
end
