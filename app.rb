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

Cuba.define do
  on 'login' do
    on post do
      handle_login(req, res, auth_service)
    end
  end

  on get, 'authors' do
    authors = File.read('AUTHORS')

    res.headers['cache-control'] = 'public, max-age=86400' # 24 hours
    res.headers['expires'] = (Time.now + 24).to_s

    res.json({ authors: authors })
  end

  on get, 'openapi.yaml' do
    openapi_spec = File.read('openapi.yaml')

    res.headers['cache-control'] = 'no-store, no-cache, must-revalidate'
    res.headers['expires'] = Time.now.to_s

    res.json({ openapi_spec: openapi_spec })
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
      res.json({ message: '[Authorization header] invalid or expired token' })
    end
  end
end
