class AuthMiddleware
  def initialize(app, auth_controller = AuthController.new)
    @app = app
    @auth_controller = auth_controller
  end

  def call(env)
    req = Rack::Request.new(env)

    if protected_route?(req.path)
      token = req.get_header('HTTP_AUTHORIZATION')

      if token.nil? || !@auth_controller.validate_session(token)
        return [401, { 'content-type' => 'application/json' }, [{ error: 'unauthorized' }.to_json]]
      end
    end

    @app.call(env)
  end

  private

  def protected_route?(path)
    path.match?(%r{\A/products(/.*)?\z})
  end
end
