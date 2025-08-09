require './app/services/auth_service'

def handle_login(req, res, auth_service)
  payload = JSON.parse(req.body.read)

  # Validate payload
  begin
    JSON::Validator.validate!(Schemas::LOGIN_ATTEMPT, payload)
  rescue JSON::Schema::ValidationError => e
    res.status = 400
    res.json({ error: e.message })
  end

  username = payload['username']
  password = payload['password']

  token = auth_service.login(username, password)

  if token
    res.status = 200
    res.json({ token: token[:value], expires_at: token[:expires_at] })
  else
    res.status = 401
    res.json({ error: 'invalid credentials' })
  end
end
