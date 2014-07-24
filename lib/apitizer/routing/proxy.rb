module Apitizer
  module Routing
    class Proxy
      def initialize(owner, options = {})
        @owner = owner
        @options = options
      end

      def method_missing(name, *arguments, &block)
        name = :"define_#{ name }"
        return super unless @owner.respond_to?(name)
        options = Helper.extract_hash!(arguments)
        @owner.send(name, *arguments, options.merge(@options), &block)
      end
    end
  end
end
