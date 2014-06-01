module Apitizer
  class Base
    def initialize(**options, &block)
      @options = Helper.deep_merge(Apitizer.defaults, options)
      @block = block
    end

    def process(*arguments)
      request = build_request(*arguments)
      response = dispatcher.process(request)
      content = translator.process(response)
      Result.new(request: request, response: response, content: content)
    end

    Apitizer.actions.each do |action|
      define_method(action) do |*arguments|
        process(action, *arguments)
      end
    end

    private

    [ :mapper, :dispatcher, :translator ].each do |component|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{ component }
          @#{ component } ||= build_#{ component }
        end
      METHOD
    end

    def build_mapper
      Routing::Mapper.new(&@block)
    end

    def build_dispatcher
      Connection::Dispatcher.new(adaptor: self.adaptor,
        dictionary: self.dictionary, headers: self.headers)
    end

    def build_translator
      Processing::Translator.new(format: self.format)
    end

    def build_request(*arguments)
      action, steps, parameters = prepare(*arguments)
      path = mapper.trace(action, steps)
      Connection::Request.new(action: action, path: path,
        parameters: parameters)
    end

    def prepare(action, *path)
      parameters = path.last.is_a?(Hash) ? path.pop : {}
      [ action.to_sym, path.flatten.map(&:to_sym), parameters ]
    end

    def method_missing(name, *arguments, &block)
      return @options[name] if @options.key?(name)
      super
    end
  end
end
