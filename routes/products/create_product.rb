def create_product(req, res)
  payload = JSON.parse(req.body.read)

  # Validate payload
  begin
    JSON::Validator.validate!(Schemas::CREATE_PRODUCT, payload)
  rescue JSON::Schema::ValidationError => e
    res.status = 400
    res.json({ error: e.message })
  end

  product_name = payload['name']

  # TODO: create asynchronously
  begin
    Product.create(name: product_name)
  rescue Sequel::Error => e
    res.status = 400
    res.json({ error: e.message })
    return
  end

  res.status = 202
  res.json({ message: "#{product_name} creation started successfully." })
end
