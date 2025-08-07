require 'json'
require 'json-schema'
require 'cuba'

require './config/database'
require './models/user'
require './models/session'
require './models/product'
require './schemas/user'
require './schemas/product'
require './services/auth_service'

require './routes/login/handle_login'
require './routes/products/retrieve_all_products'
require './routes/products/retrieve_product_by_id'
require './routes/products/create_product'
require './routes/authors/retrieve_authors'
require './routes/openapi/retrieve_openapi_spec'

# Initialize services
auth_service = AuthService.new

Cuba.define do
  on 'login' do
    on post do
      handle_login(req, res, auth_service)
    end
  end

  on 'products' do
    on root, get do
      retrieve_all_products
    end

    on ':id' do |id|
      on get do
        retrieve_product_by_id(id, res)
      end
    end

    on post do
      create_product(req, res)
    end
  end

  on 'openapi' do
    on get do
      retrieve_openapi_spec
    end
  end

  on 'authors' do
    on get do
      retrieve_authors
    end
  end
end
