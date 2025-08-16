web: rerun rackup
worker: bundle exec sidekiq -C ./app/config/sidekiq.yaml -r ./app/workers/products_processor_worker.rb
test: bundle exec rspec --format progress --color