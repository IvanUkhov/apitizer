require_relative 'format/json'
require_relative 'format/yaml'

module Apitizer
  module Format
    Error = Class.new(Apitizer::Error)

    def self.build(name)
      self.const_get(name.to_s.upcase).new
    rescue NameError
      raise Error, 'Unknown format'
    end
  end
end
