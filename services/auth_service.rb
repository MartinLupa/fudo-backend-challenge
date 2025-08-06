require 'securerandom'

class AuthService
  def login(username, password)
    user = User.find(username: username)

    return nil unless user && validate_password(user.password, password)

    token = generate_token

    Session.update_or_create({ username: username },
                             session_token: token[:value],
                             username: username,
                             expires_at: token[:expires_at])

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

  def validate_session(token)
    session = Session.find(session_token: token)
    return nil if session.nil? || session[:expires_at] <= Time.now

    session
  end
end
