module Apitizer
  module Connection
    class Response
      attr_reader :code, :content

      def initialize(options)
        @code = options.fetch(:code)
        @content = options.fetch(:content)
      end
    end
  end
end
