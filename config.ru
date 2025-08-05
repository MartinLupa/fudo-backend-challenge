# frozen_string_literal: true

require './app'
require 'rackup'
require 'dotenv/load'

Rackup::Server.start(app: FudoAPI.new, Port: ENV['SERVER_PORT'])
