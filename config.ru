# frozen_string_literal: true

require 'rack'
require 'rackup'
require 'rack/builder'
require 'dotenv/load'

require './app'

app = Rack::Builder.new do
  use Rack::Deflater # Enables the Accept-Encoding header for gzip
  run Cuba
end

Rackup::Server.start(
  app: app,
  Port: 3000,
  environment: ENV['RACK_ENV'] || 'development'
)
