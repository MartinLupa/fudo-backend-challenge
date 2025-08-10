require './app/config/database'
require 'sequel'

# Represents a product in the system. Validates that the name attribute is present.
class Product < Sequel::Model
  plugin :json_serializer
  plugin :validation_helpers
  def validate
    super
    validates_presence %i[name]
  end
end
