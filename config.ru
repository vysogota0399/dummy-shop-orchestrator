require 'bundler'

Bundler.require
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'orchestrator'
require 'app/api'

run Api
