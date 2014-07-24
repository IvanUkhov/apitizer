module Apitizer
  module Routing
    module Node
      class Operation < Base
        def initialize(name, options = {})
          @name = name
          @action = options.fetch(:action)
          @on = options.fetch(:on)
        end

        def recognize?(steps)
          @name == steps.first || @name.to_s =~ /^:/
        end

        def permit?(action, options)
          @action == action && @on == options.fetch(:on)
        end

        def on?(on)
          @on == on
        end

        private

        def walk(steps, path)
          path.advance(steps.shift, node: self, on: @on)
        end
      end
    end
  end
end
