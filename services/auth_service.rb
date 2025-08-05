require 'securerandom'

class AuthService
  def authenticate(username, password)
    puts 'Authenticating user'

    # Get the user from the DB

    # Check that the password ash in the DB matches the password hash in the incoming payload

    # If it doesnt match return token nil

    # If it matches return new token and refresh token in db
    token = generate_token
  end

  def generate_token
    SecureRandom.hex(64)
  end

  def hash_password(password)
    Digest::SHA256.hexdigest("#{password}@fudo_salt")
  end
end
