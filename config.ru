# frozen_string_literal: true

require 'rackup'
require 'dotenv/load'
require './app'

run Cuba

Rackup::Server.start(
  app: Cuba,
  Port: ENV['SERVER_PORT'] || 3000,
  environment: ENV['RACK_ENV'] || 'development'
)

# app = Rack::Builder.new do
#   use AuthMiddleware
#   use Rack::Deflater
#   use Rack::Static, {
#     root: '.',
#     urls: ['/AUTHORS', '/openapi.yaml'],
#     headers_rules: [
#       ['/AUTHORS', { 'Cache-Control' => 'public, max-age=86400' }],
#       ['/openapi.yaml', { 'Cache-Control' => 'no-cache, must-revalidate' }]
#     ]
#   }
#   use Rack::Sendfile
#   run Cuba
# end

# run app
