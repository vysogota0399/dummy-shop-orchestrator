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
          before_transition any => :damaged do |order, _transition| 
            error = order.signal_params[:error]
            order.update(error: {
              message: error.message,
              backtrace: error.backtrace.first(3),
            })
          end
        end
      end
    end
  end
end