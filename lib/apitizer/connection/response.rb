module Apitizer
  module Connection
    class Response
      attr_reader :code, :content

      def initialize(code:, content:)
        @code = code
        @content = content
      end
    end
  end
end
