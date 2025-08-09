require 'json'
require 'json-schema'
require 'cuba'
require 'rack/cors'

require './app/config/database'
require './app/models/user'
require './app/models/session'
require './app/models/product'
require './app/routes/login/handle_login'
require './app/schemas/user'
require './app/schemas/product'
require './app/services/auth_service'
require './app/controllers/products_controller'

# Initialize services
auth_service = AuthService.new

# Initialize middlewares
Cuba.use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end
Cuba.use Rack::Deflater
Cuba.use Rack::Static, {
  root: '.',
  urls: ['/AUTHORS', '/openapi.yaml', '/README.md'],
  headers_rules: [
    ['/AUTHORS', { 'Cache-Control' => 'public, max-age=86400' }],
    ['/openapi.yaml', { 'Cache-Control' => 'no-cache, must-revalidate' }],
    ['/README.md', { 'Cache-Control' => 'no-cache, must-revalidate' }]
  ]
}
Cuba.use Rack::Sendfile

# App definition
Cuba.define do
  on 'login' do
    on post do
      handle_login(req, res, auth_service)
    end
  end

  on 'products' do
    valid_session = auth_service.validate_session(req.get_header('HTTP_AUTHORIZATION'))

    if valid_session
      on root, get do
        ProductsController.get_all(res)
      end

      on ':id' do |id|
        on get do
          ProductsController.get_by_id(id, res)
        end
      end

      on post do
        ProductsController.create_async(req, res)
      end
    else
      res.status = 401
      res.json({ error: 'invalid or expired token' })
    end
  end
end
