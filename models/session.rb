require 'sequel'

unless DB.table_exists?(:sessions)
  DB.create_table :sessions do
    primary_key :id
    String :session_token, null: false
    String :username, null: false
    DateTime :expires_at
  end
end

# Represents a user session in the system, with attributes for session token,
# username, and expiration time. Validates that these attributes are present.
class Session < Sequel::Model
  plugin :json_serializer
  plugin :validation_helpers
  def validate
    super
    validates_presence %i[session_token username expires_at]
  end
end
