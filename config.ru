# frozen_string_literal: true

require 'rack'
require 'rackup'
require 'rack/builder'
require 'dotenv/load'

require './middlewares/session_validator'

require './app'

app = Rack::Builder.new do
  # use Rack::Etag            # Add an ETag
  # use Rack::ConditionalGet  # Support Caching
  # use Rack::Deflator        # GZip
  run Cuba
end

Rackup::Server.start(
  app: app,
  Port: 3000,
  environment: ENV['RACK_ENV'] || 'development'
)
