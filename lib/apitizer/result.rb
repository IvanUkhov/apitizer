module Apitizer
  class Result < SimpleDelegator
    extend Forwardable

    def_delegator :@request, :path
    def_delegator :@response, :code
    def_delegators :__getobj__, :is_a?, :kind_of?, :instance_of?

    def initialize(request:, response:)
      super(response.content)
      @request = request
      @response = response
    end
  end
end
