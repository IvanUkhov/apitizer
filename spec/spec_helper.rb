require 'webmock/rspec'
require 'apitizer'

require 'support/resource_helper'
require 'support/factory_helper'

RSpec.configure do |config|
  config.disable_monkey_patching!
end
