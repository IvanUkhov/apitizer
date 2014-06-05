require_relative 'routing/path'
require_relative 'routing/node'
require_relative 'routing/proxy'
require_relative 'routing/map'

module Apitizer
  module Routing
    Error = Class.new(Apitizer::Error)
  end
end
