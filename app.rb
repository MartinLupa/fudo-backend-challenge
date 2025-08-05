require 'json'
require 'json-schema'
require 'rack/response'

require './schemas/user'
require './services/auth_service'

class FudoAPI
  def initialize
    @auth_service = AuthService.new
  end

  def call(env)
    request = Rack::Request.new(env)

    # --------- Router ---------
    case [request.request_method, request.path_info]
    when ['POST', '/login']
      login(request)
    when ['POST', '/products']
      [202, json_headers, [JSON.generate({ data: 'Product creation accepted.', error: nil })]]
    when ['GET', '/products/:id']
      [200, json_headers, [JSON.generate({ data: 'Product with :id.', error: nil })]]
    when ['PATCH', '/products/:id']
      [200, json_headers, [JSON.generate({ data: 'Product with :id update successful.', error: nil })]]
    when ['GET', '/openapi']
      [200, json_headers, [JSON.generate({ data: 'OpenAPI spec file.', error: nil })]]
    when ['GET', '/authors']
      [200, json_headers, [JSON.generate({ data: 'Authors file.', error: nil })]]
    else
      not_found
    end
  end

  def json_headers
    { 'content-type' => 'application/json' }
  end

  # --------- Route handlers ---------
  def login(request)
    body = request.body.read

    # Validate body
    begin
      JSON::Validator.validate!(Schemas::LOGIN_ATTEMPT, body)
    rescue JSON::Schema::ValidationError => e
      return [400, json_headers, [JSON.generate({ data: nil, error: e.message })]]
    end

    username = body['username']
    password = body['password']

    token = @auth_service.authenticate(username, password)

    if token
      [200, json_headers, [JSON.generate({ token: token, expires_in: 3600 })]]
    else
      [401, json_headers, [JSON.generate({ error: 'Invalid credentials' })]]
    end
  end

  def create_product
  end

  def find_product_by_id
  end

  def update_product
  end

  def openapi_spec
  end

  def list_authors
  end

  def not_found
    [404, json_headers, [JSON.generate({ data: nil, error: 'Not found' })]]
  end
end
