RSpec.describe 'ProductsController' do
  let!(:user) { build(:user) }

  # POST to /login to generate valid token for all tests
  let(:auth_headers) do
    post '/login', JSON.generate({
                                   username: user.username,
                                   password: user.password
                                 }), { 'CONTENT_TYPE' => 'application/json' }

    parsed_body = JSON.parse(last_response.body)
    { 'HTTP_AUTHORIZATION' => parsed_body['token'] }
  end

  describe 'GET /products' do
    it 'returns all products' do
      puts "@auth_headers: #{auth_headers}"
      # get '/products', {}, auth_headers
      # expect(last_response.status).to eq(200)

      # response = json_response
      # expect(response['products']).to be_an(Array)
      # expect(response['products'].length).to eq(2)
    end

    it 'returns message when no products exist' do
      # Product.dataset.delete

      # get '/products', {}, auth_headers(user)

      # expect(last_response.status).to eq(200)
      # response = json_response
      # expect(response['products']).to eq('no products found')
    end
  end

  describe 'GET /products/:id' do
    it 'returns a specific product' do
      # get "/products/#{product1.id}", {}, auth_headers(user)

      # expect(last_response.status).to eq(200)
      # expect(CacheService.exists?("product:#{product1.id}")).to be true

      # response = json_response
      # expect(response['product']['name']).to eq('Product 1')
      # expect(response['product']['id']).to eq(product1.id)
    end

    it 'returns 404 for non-existent product' do
      # get '/products/99999', {}, auth_headers(user)

      # expect(last_response.status).to eq(404)
      # response = json_response
      # expect(response['error']).to include('product with id# 99999 not found')
    end
  end

  describe 'POST /products' do
    it 'queues product creation job' do
      # expect(ProductProcessorWorker).to receive(:perform_in).with(5, 'New Product').and_return('job123')

      # post '/products', JSON.generate({
      #                                   name: 'New Product'
      #                                 }), auth_headers(user).merge({ 'CONTENT_TYPE' => 'application/json' })

      # expect(last_response.status).to eq(202)

      # response = json_response
      # expect(response['message']).to include('New Product creation will start in 5 seconds')
      # expect(response['job_id']).to eq('job123')
    end

    it 'returns 409 for duplicate product name' do
      # post '/products', JSON.generate({
      #                                   name: 'Product 1'
      #                                 }), auth_headers(user).merge({ 'CONTENT_TYPE' => 'application/json' })

      # expect(last_response.status).to eq(409)
      # response = json_response
      # expect(response['error']).to include('a product with name #Product 1 already exists')
    end

    it 'returns 400 for invalid request format' do
      # post '/products', JSON.generate({
      #                                   invalid_field: 'value'
      #                                 }), auth_headers(user).merge({ 'CONTENT_TYPE' => 'application/json' })

      # expect(last_response.status).to eq(400)
    end
  end

  describe 'GET /jobs/:job_id/status' do
    it 'returns job status from Redis' do
      # redis = instance_double(Redis)
      # allow(Redis).to receive(:new).and_return(redis)
      # allow(redis).to receive(:get).with('job:123:status').and_return('completed')

      # get '/jobs/123/status', {}, auth_headers(user)

      # expect(last_response.status).to eq(200)
      # response = json_response
      # expect(response['status']).to eq('completed')
    end

    it 'returns unknown for non-existent job' do
      # redis = instance_double(Redis)
      # allow(Redis).to receive(:new).and_return(redis)
      # allow(redis).to receive(:get).with('job:999:status').and_return(nil)

      # get '/jobs/999/status', {}, auth_headers(user)

      # expect(last_response.status).to eq(200)
      # response = json_response
      # expect(response['status']).to eq('unknown')
    end
  end
end
