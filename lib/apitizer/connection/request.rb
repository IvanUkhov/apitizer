module Apitizer
  module Connection
    class Request
      extend Forwardable

      attr_reader :method, :path, :parameters
      def_delegator :path, :address

      def initialize(method:, path:, parameters: {})
        @method = method
        @path = path
        @parameters = parameters
      end
    end
  end
end
