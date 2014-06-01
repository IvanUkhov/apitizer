module Apitizer
  class Result < SimpleDelegator
    extend Forwardable

    def_delegator :@request, :path
    def_delegator :@response, :code

    def initialize(request:, response:, content:)
      super(content)
      @request = request
      @response = response
    end
  end
end
