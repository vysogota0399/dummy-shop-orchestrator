# frozen_string_literal: true

class Processor
  attr_reader :state_machine_instance

  def initialize(state_machine_instance)
    @state_machine_instance = state_machine_instance
  end

  def process_transition(transition: '', params: {})
    state_machine_instance.send(transition, params)
  end
end
