module Schemas
  CREATE_PRODUCT = {
    type: 'object',
    required: %w[name],
    properties: {
      name: {
        type: 'string',
        minimum: 3,
        maximum: 20
      }
    },
    additionalProperties: false
  }.freeze
end
