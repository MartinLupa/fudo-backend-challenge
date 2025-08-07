# frozen_string_literal: true

require 'rack'
require 'rackup'
require 'rack/builder'
require 'dotenv/load'

require './middlewares/session_validator'

require './app'

app = Rack::Builder.new do
  use Rack::Deflater # Enables the Accept-Encoding header
  use Rack::Static, {
    root: '.',
    urls: ['/authors', '/openapi.yaml'],
    headers_rules: [
      ['/AUTHORS', { 'cache-control' => 'public, max-age=86400' }],
      ['/openapi.yaml', { 'cache-control' => 'no-cache, must-revalidate' }]
    ]
  }
  run Cuba
end

Rackup::Server.start(
  app: app,
  Port: 3000,
  environment: ENV['RACK_ENV'] || 'development'
)
