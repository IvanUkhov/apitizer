module Apitizer
  module Routing
    module Node
      class Base
        def append(child)
          children << child
        end

        def assemble(request, path)
          process(request, path)
          return authorize(request) if path.empty?
          lookup!(path.first).assemble(request, path)
        end

        def match(name)
        end

        def process(request, path)
        end

        def permitted?(request)
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

        def authorize(request)
          raise Error, 'Not permitted' unless permitted?(request)
          request.sign(self)
          request
        end
      end
    end
  end
end
