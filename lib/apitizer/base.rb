module Apitizer
  class Base
    def initialize(**options, &block)
      raise Error, 'Block is required' unless block_given?
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

    def mapper
      @mapper ||= Routing::Mapper.new(&@block)
    end

    def dispatcher
      @dispatcher ||= Connection::Dispatcher.new(format: self.format,
        adaptor: adaptor, dictionary: dictionary, headers: headers)
    end

    def build_request(*arguments)
      action, steps, parameters = prepare_arguments(*arguments)
      path = mapper.trace(action, steps)
      Connection::Request.new(action: action, path: path,
        parameters: parameters)
    end

    def prepare_arguments(action, *path)
      parameters = path.last.is_a?(Hash) ? path.pop : {}
      [ action.to_sym, path.flatten.map(&:to_sym), parameters ]
    end

    def method_missing(name, *arguments, &block)
      return @options[name] if @options.key?(name)
      super
    end
  end
end
