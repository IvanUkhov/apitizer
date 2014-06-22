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

    def self.prepare_parameters(value)
      # PATCH 1: https://github.com/rack/rack/issues/557
      # PATCH 2: https://github.com/rack/rack/pull/698
      case value
      when NilClass, String
        value
      when Symbol, Integer, TrueClass, FalseClass
        value.to_s
      when Array
        value = value.map { |v| prepare_parameters(v) }.compact
        value.empty? ? nil : value
      when Hash
        value = Hash[
          value.map do |k, v|
            v = prepare_parameters(v)
            v.nil? ? nil : [ k, v ]
          end.compact
        ]
        value.empty? ? nil : value
      else
        if value.respond_to?(:to_a)
          prepare_parameters(value.to_a)
        elsif value.respond_to?(:to_h)
          prepare_parameters(value.to_h)
        else
          raise ArgumentError, 'Unknown parameter class'
        end
      end
    end

    private_class_method :prepare_parameters
  end
end
