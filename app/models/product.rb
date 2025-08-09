require './app/config/database'

# TODO: move table creation/migrations logic out of the app's logic
unless DB.table_exists?(:products)
  DB.create_table :products do
    primary_key :id
    String :name, unique: true, null: false
  end
end

# Represents a product in the system. Validates that the name attribute is present.
class Product < Sequel::Model
  plugin :json_serializer
  plugin :validation_helpers
  def validate
    super
    validates_presence %i[name]
  end
end
