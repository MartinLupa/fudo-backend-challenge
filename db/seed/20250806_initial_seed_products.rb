require './app/models/product'

Sequel.seed(:development) do
  def run
    [
      'Pizza - Pepperoni',
      'Pizza - Margherita',
      'Not Pizza - Hawaiian',
      'Pizza - Vegetarian',
      'Pizza - Bacon'
    ].each do |name|
      begin
        Product.find_or_create(name: name)
      rescue Sequel::Error => e
        puts "Error seeding database: #{e.message}"
      end
    end
  end
end