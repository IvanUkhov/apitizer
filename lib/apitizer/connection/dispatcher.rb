module Apitizer
  module Connection
    class Dispatcher
      def initialize(adaptor: :standard, headers: {})
        @headers = headers
        @adaptor = Adaptor.build(adaptor)
      end

      def send(action, path, parameters = {})
        request = Connection::Request.new(action: action,
          path: path, parameters: parameters)
        method = Helper.translate_action(request.action)
        code, _, body = @adaptor.process(method, request.address,
          request.parameters, @headers)
        Response.new(code: code.to_i, body: body)
      end
    end
  end
end
