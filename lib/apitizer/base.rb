module Apitizer
  class Base
    extend Forwardable

    private def_delegator :dispatcher, :process, :dispatch
    private def_delegator :translator, :process, :translate

    def initialize(**options, &block)
      @options = options
      @block = block
    end

    def process(*arguments)
      translate(dispatch(trace(*arguments)))
    end

    Apitizer.actions.each do |action|
      define_method(action) do |*arguments|
        process(action, *arguments)
      end
    end

    [ :mapper, :dispatcher, :translator ].each do |component|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{ component }
          @#{ component } ||= build_#{ component }
        end
      METHOD
    end

    private

    def build_mapper
      Routing::Mapper.new(&@block)
    end

    def build_dispatcher
      Connection::Dispatcher.new(adaptor: self.adaptor, headers: self.headers)
    end

    def build_translator
      Processing::Translator.new(format: self.format)
    end

    def prepare(action, *path)
      parameters = path.last.is_a?(Hash) ? path.pop : {}
      [ action.to_sym, path.flatten.map(&:to_sym), parameters ]
    end

    def trace(*arguments)
      action, path, parameters = prepare(*arguments)
      request = Connection::Request.new(action: action, parameters: parameters)
      mapper.trace(request, path)
    end

    def method_missing(name, *arguments, &block)
      return @options[name] if @options.key?(name)
      return Apitizer.defaults[name] if Apitizer.defaults.key?(name)
      super
    end
  end
end
