require 'yaml'

module Apitizer
  module Format
    class YAML
      def mime_type
        'application/x-yaml'
      end

      def process(data)
        ::YAML.load(data)
      rescue
        raise Error, 'Unable to parse'
      end
    end
  end
end
