require './models/user'
require './services/auth_service'

Sequel.seed(:development) do
  def run
    auth_service = AuthService.new
    [
      ['admin', auth_service.hash_password('admin')],
      ['user', auth_service.hash_password('user')]
    ].each do |username, password|
      User.create username: username, password: password
    end
  end
end
