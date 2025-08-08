# frozen_string_literal: true

require 'rack'
require 'rackup'
require 'rack/builder'
require 'dotenv/load'

require './app'

app = Rack::Builder.new do
  use Rack::Deflater # Enables the Accept-Encoding header for gzip
  use Rack::Static, {
    root: '.',
    urls: ['/AUTHORS', '/openapi.yaml'],
    headers_rules: [
      ['/AUTHORS', { 'cache-control' => 'public, max-age=86400', 'expires' => Time.now + 24 }],
      ['/openapi.yaml', { 'cache-control' => 'no-cache, must-revalidate', 'expires' => Time.now }]
    ]
  }
  use Rack::Sendfile # https://www.rubydoc.info/gems/rack/Rack/Sendfile for nginx config
  run Cuba
end

Rackup::Server.start(
  app: app,
  Port: 3000,
  environment: ENV['RACK_ENV'] || 'development'
)
