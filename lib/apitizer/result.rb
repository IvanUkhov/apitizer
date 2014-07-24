module Apitizer
  class Result < SimpleDelegator
    extend Forwardable

    def_delegator :@request, :path
    def_delegator :@response, :code
    def_delegators :__getobj__, :is_a?, :kind_of?, :instance_of?

    def initialize(options)
      @request = options.fetch(:request)
      @response = options.fetch(:response)
      super(@response.content)
    end
  end
end
