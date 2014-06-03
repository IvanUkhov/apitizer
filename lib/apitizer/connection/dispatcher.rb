module Apitizer
  module Connection
    class Dispatcher
      def initialize(adaptor: :standard, dictionary:, headers: {})
        @adaptor = Adaptor.build(adaptor)
        @dictionary = dictionary
        @headers = headers
      end

      def process(request)
        method = translate(request.action)
        code, _, body = @adaptor.process(method, request.address,
          request.parameters, @headers)
        Response.new(code: code, body: body.join)
      end

      private

      def translate(action)
        @dictionary[action] or raise Error, 'Unknown action'
      end
    end
  end
end
