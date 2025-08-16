require 'rspec'
require 'rack/test'
require 'factory_bot'
require 'database_cleaner/sequel'

require_relative '../app'

# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods

  # Factory Bot setup
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

def app
  Cuba
end
