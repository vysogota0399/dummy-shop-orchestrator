# frozen_string_literal: true

class OrchestratorContainer < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch('RACK_ENV', :development).to_sym }

  configure do |config|
    config.name = :orchestrator
    config.root = 'app'

    config.component_dirs.add '../lib'
  end
end
