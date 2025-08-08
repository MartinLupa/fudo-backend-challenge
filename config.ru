# frozen_string_literal: true

require 'rackup'
require 'dotenv/load'
require './app'

run Cuba

Rackup::Server.start(
  app: Cuba,
  Port: ENV['SERVER_PORT'],
  environment: ENV['RACK_ENV'] || 'development'
)
