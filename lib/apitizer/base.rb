module Apitizer
  class Base
    extend Forwardable

    def_delegator :map, :define

    def initialize(**options, &block)
      @options = Helper.deep_merge(Apitizer.defaults, options)
      @block = block
    end

    def process(*arguments)
      request = build_request(*arguments)
      response = dispatcher.process(request)
      Result.new(request: request, response: response)
    end

    Apitizer.actions.each do |action|
      define_method(action) do |*arguments|
        process(action, *arguments)
      end
    end

    private

    def map
      @map ||= Routing::Map.new(&@block)
    end

    def dispatcher
      @dispatcher ||= Connection::Dispatcher.new(format: @options[:format],
        adaptor: @options[:adaptor], headers: @options[:headers])
    end

    def build_request(action, *arguments)
      method, steps, parameters = prepare_arguments(action, *arguments)
      Connection::Request.new(method: method, path: map.trace(action, steps),
        parameters: parameters)
    end

    def prepare_arguments(action, *path)
      parameters = path.last.is_a?(Hash) ? path.pop : {}
      [ translate(action), path.flatten.map(&:to_sym), parameters ]
    end

    def translate(action)
      @options[:dictionary][action] or raise Error, 'Unknown action'
    end
  end
end
