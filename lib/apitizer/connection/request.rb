module Apitizer
  module Connection
    class Request
      extend Forwardable

      attr_reader :method, :path, :parameters
      def_delegator :path, :address

      def initialize(options)
        @method = options.fetch(:method)
        @path = options.fetch(:path)
        @parameters = options[:parameters] || {}
      end
    end
  end
end
