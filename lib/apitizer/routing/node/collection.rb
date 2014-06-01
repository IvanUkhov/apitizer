module Apitizer
  module Routing
    module Node
      class Collection < Base
        def initialize(name, only: nil)
          @name = name
          @actions = only && Array(only) || Apitizer.actions
          unless (@actions - Apitizer.actions).empty?
            raise Error, 'Not supported'
          end
        end

        def match(name)
          @name == name
        end

        def process(path, steps)
          path << steps.shift # @name
          return path if steps.empty?
          path << steps.shift # id
        end

        def permitted?(action, path)
          return false unless @actions.include?(action)

          id_present = path.steps.last != @name
          member_action = Helper.member_action?(action)

          id_present == member_action
        end
      end
    end
  end
end
