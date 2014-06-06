module Apitizer
  module Connection
    class Dispatcher
      def initialize(format:, adaptor: :standard, headers: {})
        @format = Format.build(format)
        @adaptor = Adaptor.build(adaptor)
        @headers = headers.merge('Accept' => @format.mime_type)
      end

      def process(request)
        code, _, body = @adaptor.process(request.method, request.address,
          request.parameters, @headers)
        Response.new(code: code, content: @format.process(body.join))
      end
    end
  end
end
