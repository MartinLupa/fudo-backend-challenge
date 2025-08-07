require './workers/products_processor_worker'

class ProductsController
  def self.get_all(res)
    products = Product.all

    products_list = products.map do |product|
      {
        id: product.id,
        name: product.name
      }
    end

    res.json({ products: products_list.empty? ? 'no products found' : products_list })
  end

  def self.get_by_id(id, res)
    product = Product.first(id: id)

    unless product
      res.status = 404
      res.json({ error: "product with id# #{id} not found" })
      return
    end

    res.status = 200
    res.json(product: product.values)
  end

  def self.create_async(req, res)
    payload = JSON.parse(req.body.read)

    # Validate payload
    begin
      JSON::Validator.validate!(Schemas::CREATE_PRODUCT, payload)
    rescue JSON::Schema::ValidationError => e
      res.status = 400
      res.json({ error: e.message })
    end

    product_name = payload['name']

    ProductProcessorWorker.perform_in(5, product_name)

    res.status = 202
    res.json({ message: "#{product_name} creation will start in 5 seconds." })
  end
end
