module Apitizer
  module Processing
    class Translator
      def initialize(format:)
        @parser = Parser.build(format)
      end

      def process(response)
        @parser.process(response.body)
      end
    end
  end
end
