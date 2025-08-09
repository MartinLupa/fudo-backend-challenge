class ApplicationController
  # To validate incoming payloads against a specific schema
  def parse_and_validate(req, res, schema)
    payload = JSON.parse(req.body.read)
    JSON::Validator.validate!(schema, payload)
    payload
  rescue JSON::Schema::ValidationError => e
    res.status = 400
    res.json(error: e.message)
    nil
  end

  # Not found reusable response
  def render_not_found(entity, attribute, value, res)
    res.status = 404
    res.json(error: "#{entity} with #{attribute}# #{value} not found")
  end
end