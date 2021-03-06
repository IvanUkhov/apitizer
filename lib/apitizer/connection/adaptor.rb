require_relative 'adaptor/standard'

module Apitizer
  module Connection
    module Adaptor
      def self.build(name)
        self.const_get(name.to_s.capitalize).new
      rescue NameError
        raise Error, 'Unknown adaptor'
      end
    end
  end
end
