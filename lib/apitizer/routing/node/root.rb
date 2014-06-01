module Apitizer
  module Routing
    module Node
      class Root < Base
        def define_address(address, *_)
          @address = address
        end

        def process(path, steps)
          path << @address unless @address.nil?
        end
      end
    end
  end
end
