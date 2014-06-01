module Apitizer
  module Connection
    class Request
      extend Forwardable

      attr_reader :action, :path, :parameters
      def_delegator :path, :address

      def initialize(action:, path:, parameters: {})
        @action = action
        @path = path
        @parameters = parameters
      end
    end
  end
end
