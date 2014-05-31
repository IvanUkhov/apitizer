module Apitizer
  module Helper
    Error = Class.new(Apitizer::Error)

    def self.member_action?(action)
      if Apitizer.member_actions.include?(action)
        true
      elsif Apitizer.collection_actions.include?(action)
        false
      else
        raise Error, 'Unknown action'
      end
    end

    def self.translate_action(action)
      Apitizer.action_dictionary[action] or raise Error, 'Unknown action'
    end

    def self.build_query(parameters)
      Rack::Utils.build_nested_query(prepare_parameters(parameters))
    end

    private

    def self.prepare_parameters(parameters)
      # PATCH: https://github.com/rack/rack/issues/557
      Hash[
        parameters.map do |key, value|
          case value
          when Integer, TrueClass, FalseClass
            [ key, value.to_s ]
          when Hash
            [ key, prepare_parameters(value) ]
          else
            [ key, value ]
          end
        end
      ]
    end
  end
end
