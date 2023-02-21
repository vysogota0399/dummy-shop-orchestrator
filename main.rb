require 'bundler/setup'

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'dry-auto_inject'
require 'dry-container'
require 'dry-system'
require 'byebug'

require 'system/orchestrator_container'
require 'orchestrator'

OrchestratorContainer.finalize!
