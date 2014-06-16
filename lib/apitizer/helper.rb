require 'rack/utils'

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

    def self.action_scope(action)
      member_action?(action) ? :member : :collection
    end

    def self.deep_merge(one, two)
      merger = Proc.new do |key, v1, v2|
        Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2
      end
      one.merge(two, &merger)
    end

    def self.build_query(parameters)
      query = Rack::Utils.build_nested_query(prepare_parameters(parameters))
      query.encode!('UTF-8')
    end

    private

    def self.prepare_parameters(parameters)
      # PATCH 1: https://github.com/rack/rack/issues/557
      # PATCH 2: https://github.com/rack/rack/pull/698
      Hash[
        parameters.map do |key, value|
          case value
          when Integer, TrueClass, FalseClass
            [ key, value.to_s ]
          when Hash
            [ key, prepare_parameters(value) ]
          when Array
            value.empty? ? nil : [ key, value ]
          else
            [ key, value ]
          end
        end.compact
      ]
    end
  end
end
