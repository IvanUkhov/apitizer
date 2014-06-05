module Apitizer
  module Routing
    class Map
      extend Forwardable

      def_delegator :@root, :define_address

      def initialize(&block)
        @root = Node::Root.new
        define(&block) if block_given?
      end

      def trace(action, steps)
        path = @root.trace(steps) or raise Error, 'Not found'
        raise Error, 'Not permitted' unless path.permit?(action)
        path
      end

      def define(&block)
        proxy = Proxy.new(self)
        proxy.instance_eval(&block)
      end

      def define_resources(name, parent: @root, **options, &block)
        child = Node::Collection.new(name, **options)
        parent.append(child)
        return unless block_given?
        proxy = Proxy.new(self, parent: child)
        proxy.instance_eval(&block)
      end

      Apitizer.actions.each do |action|
        define_method "define_#{ action }" do |name, parent:, **options|
          child = Node::Operation.new(name, action: action, **options)
          parent.append(child)
        end
      end
    end
  end
end
