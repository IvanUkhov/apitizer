module Apitizer
  module Connection
    class Dispatcher
      def initialize(options)
        @format = Format.build(options.fetch(:format))
        @adaptor = Adaptor.build(options[:adaptor] || :standard)
        @headers = options[:headers] || {}
        @headers.merge!('Accept' => @format.mime_type)
      end

      def process(request)
        code, _, body = @adaptor.process(request.method, request.address,
          request.parameters, @headers)
        Response.new(code: code, content: @format.process(body.join))
      end
    end
  end
end
