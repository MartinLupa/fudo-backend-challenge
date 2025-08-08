# frozen_string_literal: true

require 'rackup'
require 'dotenv/load'

require './app'

run Cuba

Rackup::Server.start(
  app: Cuba,
  Port: 3000,
  environment: ENV['RACK_ENV'] || 'development'
)
