module Concerns
  module Base
    attr_accessor :signal_params

    def self.included(base)
      base.class_eval do
        state_machine initial: :new do
          around_transition do |order, transition, block|
            order.signal_params = (transition.args.first || {}).with_indifferent_access
            block.call
          end

          event :terminate do
            transition any => :damaged
          end
        end
      end
    end
  end
end