require 'sidekiq'
require './models/product'
require './config/database'

# Processes product creation asynchronously.
class ProductProcessorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'standard', retry: 3

  def perform(product_name)
    Product.create(name: product_name)
  end
end
