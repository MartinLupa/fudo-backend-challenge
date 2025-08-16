RSpec.describe 'AuthController' do
  describe 'POST /login' do
    context 'with invalid credentials' do
      it 'returns 401 for non-existent user' do
        post '/login', JSON.generate({
                                       username: 'nonexistent_user',
                                       password: 'nonexistent_password'
                                     }), { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(401)
      end
      it 'returns 401 for wrong password' do
        post '/login', JSON.generate({
                                       username: 'test_user',
                                       password: 'wrong_password'
                                     }), { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(401)
        # expect(last_response.body.inspect['error']).to eq('invalid credentials')
      end
    end

    context 'with valid credentials' do
      it 'returns a token' do
        post '/login', JSON.generate({
                                       username: 'test_user',
                                       password: 'test_user'
                                     }), { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(200)
        # expect(response['token']).to be_present
      end
    end
  end
end
