# frozen_string_literal: true

class Orchestrator < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch('APP_ENV', :development).to_sym }
  use :logging

  # logger
  setting :log_dir, default: 'log'

  configure do |config|
    config.name = :orchestrator
    config.root = '.'

    config.component_dirs.add 'lib'
  end
end
