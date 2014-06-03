require 'json'

module Apitizer
  module Format
    class JSON
      def mime_type
        'application/json'
      end

      def process(data)
        ::JSON.parse(data)
      rescue
        raise Error, 'Unable to parse'
      end
    end
  end
end
