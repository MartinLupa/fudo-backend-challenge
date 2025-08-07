def retrieve_product_by_id(id, res)
  product = Product.first(id: id)

  unless product
    res.status = 404
    res.json({ error: "product with id# #{id} not found" })
    return
  end
  res.status = 200
  res.json(product: product.values)
rescue Sequel::Error => e
  res.status = 500
  res.json(error: e)
end
