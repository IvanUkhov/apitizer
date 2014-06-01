module Apitizer
  module Routing
    module Node
      class Scope < Base
        def initialize(steps)
          @steps = Array(steps)
        end

        def match(name)
          not lookup(name).nil?
        end

        def process(path, steps)
          @steps.each { |step| path << step }
        end
      end
    end
  end
end
