require 'json'
require 'json-schema'
require 'cuba'
require 'rack/cors'

require './app/config/database'

require './app/controllers/app_controller'
require './app/controllers/auth_controller'
require './app/controllers/products_controller'

require './app/models/user'
require './app/models/session'
require './app/models/product'

require './app/schemas/user'
require './app/schemas/product'

# Controllers
auth_controller = AuthController.new
products_controller = ProductsController.new

# Middlewares
Cuba.use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post options]
  end
end
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

# Routes
Cuba.define do
  on 'login' do
    on post do
      auth_controller.login(req, res)
    end
  end

  on 'products' do
    valid_session = auth_controller.validate_session(req.get_header('HTTP_AUTHORIZATION'))

    if valid_session
      on root, get do
        products_controller.get_all(res)
      end

      on get, 'status/:job_id' do |job_id|
        products_controller.job_status(req, res, job_id)
      end

      on ':id' do |id|
        on get do
          products_controller.get_by_id(id, res)
        end
      end

      on post do
        products_controller.create_async(req, res)
      end
    else
      res.status = 401
      res.json({ error: 'invalid or expired token' })
    end
  end
end



