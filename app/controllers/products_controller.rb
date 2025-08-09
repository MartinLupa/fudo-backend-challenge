require './app/workers/products_processor_worker'

# Handles HTTP requests for product-related operations, including retrieving all products,
# fetching a product by ID, and creating products asynchronously with validation.
class ProductsController < ApplicationController
  def get_all(res)
    products = Product.all

    products_list = products.map do
      |p| { id: p.id, name: p.name }
    end

    res.json({ products: products_list.empty? ? 'no products found' : products_list })
  end

  def get_by_id(id, res)
    product = Product.first(id: id)

    return render_not_found("product", "id", id, res) unless product

    res.status = 200
    res.json(product: product.values)
  end

  def create_async(req, res)
    payload = parse_and_validate(req, res, Schemas::CREATE_PRODUCT)
    return unless payload

    product_name = payload['name']

    existing_product = Product.find(name: product_name)

    if existing_product
      res.status = 409
      res.json({ error: "a product with name ##{product_name} already exists." })
      return
    end

    ProductProcessorWorker.perform_in(5, product_name)

    res.status = 202
    res.json({ message: "#{product_name} creation will start in 5 seconds." })
  end
end
