require './models/product'

Sequel.seed(:development) do
  def run
    [
      ['Pizza - Pepperoni'],
      ['Pizza - Margherita'],
      ['Not Pizza - Hawaian'],
      ['Pizza - Vegetarian'],
      ['Pizza - Bacon']
    ].each do |name|
      Product.create name: name
    end
  end
end
