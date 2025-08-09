require 'sidekiq'
require './app/models/product'

# Processes product creation asynchronously.
class ProductProcessorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'standard', retry: 3

  def perform(product_name)
    Product.create(name: product_name)
  end
end
