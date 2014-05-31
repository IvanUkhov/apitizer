require 'json'

module Apitizer
  module Processing
    module Parser
      class JSON
        def process(data)
          ::JSON.parse(data)
        rescue
          raise Error, 'Unable to parse'
        end
      end
    end
  end
end
