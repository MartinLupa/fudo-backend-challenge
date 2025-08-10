##
# ApplicationController serves as a base controller, providing shared utility methods
# for request validation and common HTTP responses.
#
# Responsibilities:
# - Validates incoming request payloads against predefined JSON schemas.
# - Provides a reusable "not found" response for missing resources.
#
# Methods:
# - parse_and_validate(req, res, schema): Parses request JSON and validates it against a schema.
# - render_not_found(entity, attribute, value, res): Returns a standardized 404 response.
#
class ApplicationController
  def parse_and_validate(req, res, schema)
    payload = JSON.parse(req.body.read)
    JSON::Validator.validate!(schema, payload)
    payload
  rescue JSON::Schema::ValidationError => e
    res.status = 400
    res.json(error: e.message)
    nil
  end

  def render_not_found(entity, attribute, value, res)
    res.status = 404
    res.json(error: "#{entity} with #{attribute}# #{value} not found")
  end
end