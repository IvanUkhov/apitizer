require_relative 'processing/parser'
require_relative 'processing/translator'

module Apitizer
  module Processing
    Error = Class.new(Apitizer::Error)
  end
end
