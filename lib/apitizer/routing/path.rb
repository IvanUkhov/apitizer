module Apitizer
  module Routing
    class Path
      attr_reader :steps, :node

      def initialize(options = {})
        @steps = options[:steps] || []
        @node = options[:node]
      end

      def address
        @steps.map(&:to_s).join('/')
      end

      def advance(step, options)
        @steps << step
        @node = options.fetch(:node)
        @on = options[:on]
      end

      def permit?(action)
        @node && @node.permit?(action, on: @on)
      end

      def on?(on)
        @on == on
      end

      def clone
        self.class.new(steps: @steps.clone, node: @node)
      end
    end
  end
end
