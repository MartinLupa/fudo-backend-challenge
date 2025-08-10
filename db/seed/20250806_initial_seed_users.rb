require './app/models/user'
require './app/controllers/auth_controller'

Sequel.seed(:development) do
  def run
    auth_controller = AuthController.new
    [
      ['admin', auth_controller.hash_password('admin')],
      ['user', auth_controller.hash_password('user')]
    ].each do |username, password|
      begin
        User.find_or_create(username: username, password: password)
      rescue Sequel::Error => e
        puts "Error seeding database: #{e.message}"
      end
    end
  end
end
