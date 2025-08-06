require 'securerandom'

class AuthService
  def authenticate(username, password)
    user = User.find(username: username)

    return nil unless user && validate_password(user.password, password)

    token = generate_token

    user.update(
      session_token: token[:value],
      session_valid_until: token[:expires_at],
      last_login: Time.now
    )

    token
  end

  def generate_token
    { value: SecureRandom.hex(64), expires_at: Time.now + 3600 }
  end

  def hash_password(password)
    Digest::SHA256.hexdigest("#{password}@fudo_salt")
  end

  def validate_password(db_password, login_password)
    db_password == hash_password(login_password)
  end
end
