module Apitizer
  module Routing
    module Node
      class Root < Base
        def recognize?(steps)
          true
        end

        def define_address(address, *_)
          @address = address
        end

        private

        def walk(steps, path)
          path.advance(@address, node: self) if @address
        end
      end
    end
  end
end
