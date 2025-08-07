def retrieve_all_products
  products = Product.all

  products_list = products.map do |product|
    {
      id: product.id,
      name: product.name
    }
  end

  res.json({ products: products_list.empty? ? 'no products found' : products_list })
end
