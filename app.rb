require 'json'
require 'json-schema'
require 'cuba'

require './config/database'
require './models/user'
require './models/session'
require './models/product'
require './routes/login/handle_login'
require './routes/authors/handle_authors'
require './routes/openapi/handle_openapi'
require './schemas/user'
require './schemas/product'
require './services/auth_service'
require './controllers/products_controller'

# Initialize services
auth_service = AuthService.new

Cuba.use Rack::Deflater
Cuba.use Rack::Static, {
  root: '.',
  urls: ['/AUTHORS', '/openapi.yaml'],
  headers_rules: [
    ['/AUTHORS', { 'Cache-Control' => 'public, max-age=86400' }],
    ['/openapi.yaml', { 'Cache-Control' => 'no-cache, must-revalidate' }]
  ]
}
Cuba.use Rack::Sendfile

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
