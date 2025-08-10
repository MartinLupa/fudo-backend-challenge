# Represents a user in the system, with username and password attributes.
# Validates that these attributes are present.
class User < Sequel::Model
  plugin :json_serializer
  plugin :validation_helpers
  def validate
    super
    validates_presence %i[username password]
  end
end
