module Apitizer
  module Routing
    module Node
      class Base
        def append(child)
          children << child
        end

        def trace(steps, path = Path.new)
          return nil unless recognize?(steps)

          steps, path = steps.clone, path.clone

          walk(steps, path)
          return path if steps.empty?

          children.each do |child|
            branch = child.trace(steps, path)
            return branch if branch
          end

          nil
        end

        def recognize?(steps)
        end

        def permit?(action, options)
        end

        private

        def walk(steps, path)
        end

        def children
          @children ||= []
        end
      end
    end
  end
end
