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

  on 'openapi' do
    on get do
      handle_openapi
    end
  end

  on 'authors' do
    on get do
      handle_authors
    end
  end

  on 'products' do
    on root, get do
      ProductController.get_all_products
    end

    on ':id' do |id|
      on get do
        ProductController.get_product_by_id(id, res)
      end
    end

    on post do
      ProductController.create_product_async(req, res)
    end
  end
end
