module Concerns
  module Core
    attr_accessor :signal_params

    def self.included(base)
      include InstanceMethods

      attr_accessor :order_update_publisher

      base.class_eval do
        after_initialize do |object|
          object.order_update_publisher = Orchestrator['order_update_publisher']
        end

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

          after_transition any => any do |order, _transition|
            serialized_order = OrderBlueprint.render(
              order, 
              {
                root: :data,
                view: :extended,
              }
            )
            order.order_update_publisher.call(serialized_order)
          end
        end
      end
    end

    module InstanceMethods; end
  end
end
