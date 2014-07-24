module Apitizer
  module Routing
    module Node
      class Collection < Base
        def initialize(name, options = {})
          @name = name
          only = options[:only]
          except = options[:except] || []
          @actions = (only && Array(only) || Apitizer.actions) - Array(except)
        end

        def recognize?(steps)
          @name == steps.first
        end

        def permit?(action, options)
          @actions.include?(action) &&
            Helper.action_scope(action) == options.fetch(:on)
        end

        private

        def walk(steps, path)
          path.advance(steps.shift, node: self, on: :collection)

          return if steps.empty?

          children.each do |child|
            next unless child.respond_to?(:on?) && child.on?(:collection)
            return if child.recognize?(steps)
          end

          path.advance(steps.shift, node: self, on: :member)
        end
      end
    end
  end
end
