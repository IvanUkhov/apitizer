module Apitizer
  module Connection
    class Dispatcher
      def initialize(format:, adaptor: :standard, dictionary:, headers: {})
        @format = Format.build(format)
        @adaptor = Adaptor.build(adaptor)
        @dictionary = dictionary
        @headers = headers.merge('Accept' => @format.mime_type)
      end

      def process(request)
        method = @dictionary[request.action] or raise Error, 'Unknown action'
        code, _, body = @adaptor.process(method, request.address,
          request.parameters, @headers)
        Response.new(code: code, content: @format.process(body.join))
      end
    end
  end
end
