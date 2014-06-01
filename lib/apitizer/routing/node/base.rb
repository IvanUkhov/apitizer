module Apitizer
  module Routing
    module Node
      class Base
        def append(child)
          children << child
        end

        def trace(steps, path = Path.new)
          process(path, steps)
          advance(path)

          return path if steps.empty?

          child = lookup(steps.first) or raise Error, 'Not found'
          child.trace(steps, path)
        end

        def match(name)
        end

        def process(path, steps)
        end

        def permitted?(action, path)
        end

        protected

        def children
          @children ||= []
        end

        def lookup(name)
          children.find { |c| c.match(name) }
        end

        def advance(path)
          path.advance(self)
        end
      end
    end
  end
end
