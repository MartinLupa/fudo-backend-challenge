require 'sequel'
require 'retriable'
require 'dotenv/load'
require 'sequel/extensions/seed'
require 'sequel/extensions/migration'

database_url = ENV['DATABASE_URL']

raise '[Missing environment variable] DATABASE_URL' if database_url.nil? || database_url.empty?

Retriable.retriable(on: Sequel::DatabaseConnectionError, tries: 3, intervals: 2) do
  DB = Sequel.connect(database_url)

  DB.test_connection

  DB.extension :connection_validator
  DB.pool.connection_validation_timeout = 3600

  puts "✅ Database connected successfully to #{database_url.gsub(/:[^:@]*@/, ':***@')}"
rescue Sequel::DatabaseConnectionError => e
  puts "❌ Database connection failed: #{e.message}"
  puts "Database URL: #{database_url}"
  raise e
end

# Enable update_or_create method (used to refresh session tokens)
Sequel::Model.plugin :update_or_create

# TODO: ideally seeding and migrations for dev should be out of the app logic
if ENV['RACK_ENV'] == 'development'
  Sequel::Migrator.run(DB, './db/migrations')

  Sequel::Seed.setup(:development)
  Sequel.extension :seed
  Sequel::Seeder.apply(DB, './db/seed')    
end