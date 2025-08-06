require 'sequel'

unless DB.table_exists?(:users)
  DB.create_table :users do
    primary_key :id
    String :username, unique: true, null: false
    String :password, null: false
  end
end

class User < Sequel::Model
  plugin :json_serializer
  plugin :validation_helpers
  def validate
    super
    validates_presence %i[username password]
  end
end
