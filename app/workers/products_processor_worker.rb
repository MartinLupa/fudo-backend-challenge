require 'sidekiq'
require 'redis'
require './app/models/product'

# Processes product creation asynchronously.
class ProductProcessorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'standard', retry: 3

  def perform(product_name)
    redis = Redis.new

    redis.set("job:#{jid}:status", "working")
    Product.create(name: product_name)
    # sleep(15) #Enable this line to give you time to test the status/job_id endpoint
    redis.set("job:#{jid}:status", "complete")

  rescue => e
    redis.set("job:#{jid}:status", "failed:#{e}")
  end
end
