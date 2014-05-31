require_relative 'connection/request'
require_relative 'connection/adaptor'
require_relative 'connection/dispatcher'
require_relative 'connection/response'

module Apitizer
  module Connection
    Error = Class.new(Apitizer::Error)
  end
end
