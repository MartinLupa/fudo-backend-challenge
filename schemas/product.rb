module Schemas
  CREATE_PRODUCT = {
    type: 'object',
    required: %w[id name],
    properties: {
      id: {
        type: 'integer',
        minimum: 0
      },
      name: {
        type: 'string',
        minimum: 3,
        maximum: 20
      }
    },
    additionalProperties: false
  }.freeze
end
