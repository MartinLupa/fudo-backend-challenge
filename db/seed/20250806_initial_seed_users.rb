require './app/models/user'
require './app/services/auth_service'

Sequel.seed(:development) do
  def run
    auth_service = AuthService.new
    [
      ['admin', auth_service.hash_password('admin')],
      ['user', auth_service.hash_password('user')]
    ].each do |username, password|
      begin
        User.find_or_create(username: username, password: password)
      rescue Sequel::Error => e
        puts "Error seeding database: #{e.message}"
      end
    end
  end
end
