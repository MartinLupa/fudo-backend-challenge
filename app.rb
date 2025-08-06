require 'json'
require 'json-schema'
require 'rack/response'

require './config/database'
require './models/user'
require './models/session'
require './models/product'
require './schemas/user'
require './schemas/product'
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
      create_product(request)
    when ['GET', '/products']
      retrieve_all_products(request)
    when ['GET', '/products/1']
      retrieve_product_by_id(request)
    when ['PATCH', '/products/1']
      update_product(request)
    when ['DELETE', '/products/1']
      delete_product(request)
    when ['GET', '/openapi']
      retrieve_openapi_spec
    when ['GET', '/authors']
      retrieve_authors
    else
      not_found
    end
  end

  def json_headers
    { 'content-type' => 'application/json' }
  end

  # --------- Route handlers ---------
  def login(request)
    body = JSON.parse(request.body.read)

    # Validate body
    begin
      JSON::Validator.validate!(Schemas::LOGIN_ATTEMPT, body)
    rescue JSON::Schema::ValidationError => e
      return [400, json_headers, [JSON.generate({ error: e.message })]]
    end

    username = body['username']
    password = body['password']

    token = @auth_service.login(username, password)

    if token
      [200, json_headers, [JSON.generate({ token: token[:value], expires_at: token[:expires_at] })]]
    else
      [401, json_headers, [JSON.generate({ error: 'invalid credentials' })]]
    end
  end

  def create_product(request)
    session = @auth_service.validate_session(request.get_header('HTTP_AUTHORIZATION'))
    return [419, json_headers, [JSON.generate({ error: 'session token is expired or invalid' })]] unless session

    body = JSON.parse(request.body.read)

    # Validate body
    begin
      JSON::Validator.validate!(Schemas::CREATE_PRODUCT, body)
    rescue JSON::Schema::ValidationError => e
      return [400, json_headers, [JSON.generate({ error: e.message })]]
    end

    product_name = body['name']

    # TODO: create asynchronously
    Product.create(name: product_name)

    [202, json_headers, [JSON.generate({ message: "#{product_name} creation started successfully." })]]
  end

  def retrieve_all_products(request)
    session = @auth_service.validate_session(request.get_header('HTTP_AUTHORIZATION'))
    return [419, json_headers, [JSON.generate({ error: 'session token is expired or invalid' })]] unless session

    products = Product.all

    [200, json_headers, [JSON.generate({ products: products })]]
  end

  def retrieve_product_by_id(request)
    session = @auth_service.validate_session(request.get_header('HTTP_AUTHORIZATION'))
    return [419, json_headers, [JSON.generate({ error: 'session token is expired or invalid' })]] unless session

    id = 1

    product = Product.find(id: id)

    [200, json_headers, [JSON.generate({ product: product })]]
  end

  def update_product(request)
    session = @auth_service.validate_session(request.get_header('HTTP_AUTHORIZATION'))
    [419, json_headers, [JSON.generate({ error: 'session token is expired or invalid' })]] unless session

    body = JSON.parse(request.body.read)

    # Validate body
    begin
      JSON::Validator.validate!(Schemas::UPDATE_PRODUCT, body)
    rescue JSON::Schema::ValidationError => e
      return [400, json_headers, [JSON.generate({ error: e.message })]]
    end

    product_id = 1
    product_name = body['name']

    product = Product.where({ id: product_id }).first
    product.update(name: product_name)

    [200, json_headers, [JSON.generate({ message: 'product name updated successfully.' })]]
  end

  def delete_product(request)
    session = @auth_service.validate_session(request.get_header('HTTP_AUTHORIZATION'))
    [419, json_headers, [JSON.generate({ error: 'session token is expired or invalid' })]] unless session

    product_id = 1

    Product[product_id].delete

    [200, json_headers, [JSON.generate({ message: "product with id: #{product_id} deleted successfully." })]]
  end

  def retrieve_openapi_spec
    openapi_spec_content = File.read('openapi.yaml')
    [200, json_headers, [JSON.generate({ openapi_spec: openapi_spec_content })]]
  end

  def retrieve_authors
    authors_content = File.read('AUTHORS')
    [200, json_headers, [JSON.generate({ authors: authors_content })]]
  end

  def not_found
    [404, json_headers, [JSON.generate({ error: '404 - not found' })]]
  end
end
