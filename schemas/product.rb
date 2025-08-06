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
  }.freeze,

                   UPDATE_PRODUCT = {
                     type: 'object',
                     required: [], # No fields are required for updates, allowing partial updates
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
