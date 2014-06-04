require_relative 'format/json'
require_relative 'format/yaml'

module Apitizer
  module Connection
    module Format
      def self.build(name)
        self.const_get(name.to_s.upcase).new
      rescue NameError
        raise Error, 'Unknown format'
      end
    end
  end
end
