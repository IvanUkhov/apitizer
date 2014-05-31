require_relative 'routing/node'
require_relative 'routing/proxy'
require_relative 'routing/mapper'

module Apitizer
  module Routing
    Error = Class.new(Apitizer::Error)
  end
end
