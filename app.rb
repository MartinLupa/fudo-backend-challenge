require 'json'

class FudoAPI
  def call(env)
    request = Rack::Request.new(env)

    # Router
    case [request.request_method, request.path_info]

    when ['POST', '/auth']
      [200, json_headers, [JSON.generate({ data: 'Authentication successful.', error: nil })]]
    when ['POST', '/products']
      [202, json_headers, [JSON.generate({ data: 'Product creation accepted.', error: nil })]]
    when ['GET', '/products/:id']
      [200, json_headers, [JSON.generate({ data: 'Product with :id.', error: nil })]]
    when ['PATCH', '/products/:id']
      [200, json_headers, [JSON.generate({ data: 'Product with :id update successful.', error: nil })]]
    when ['GET', '/openapi']
      [200, json_headers, [JSON.generate({ data: 'OpenAPI spec file.', error: nil })]]
    when ['GET', '/authors']
      get_authors
      [200, json_headers, [JSON.generate({ data: 'Authors file.', error: nil })]]
    else
      not_found
    end
  end

  def json_headers
    { 'content-type' => 'application/json' }
  end

  def auth
  end

  def create_product
  end

  def get_product_by_id
  end

  def patch_product
  end

  def get_openapi_spec
  end

  def get_authors
  end

  def not_found
    [404, json_headers, [JSON.generate({ data: nil, error: 'Not found' })]]
  end
end
