module Apitizer
  module Routing
    module Node
      class Base
        def append(child)
          children << child
        end

        def trace(steps, path = Path.new)
          process(path, steps)
          path.advance(self)
          return path if steps.empty?
          lookup!(steps.first).trace(steps, path)
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

        def lookup!(name)
          lookup(name) or raise Error, 'Not found'
        end
      end
    end
  end
end
