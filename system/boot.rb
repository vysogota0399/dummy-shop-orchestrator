# frozen_string_literal: true

require_relative 'container'
require_relative 'import'

Orchestrator.finalize!

require 'app/models'
require 'app/serializers'
require 'app/processor'
require 'app/validations'
