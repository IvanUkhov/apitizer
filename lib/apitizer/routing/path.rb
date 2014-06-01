module Apitizer
  module Routing
    class Path
      extend Forwardable

      attr_reader :steps, :node
      def_delegators :steps, :<<

      def initialize
        @steps = []
      end

      def address
        @steps.map(&:to_s).join('/')
      end

      def advance(node)
        @node = node
      end

      def permitted?(action)
        @node && @node.permitted?(action, self)
      end
    end
  end
end
