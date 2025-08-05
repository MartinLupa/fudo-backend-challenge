module Schemas
  LOGIN_ATTEMPT = {
    type: 'object',
    required: %w[username password],
    properties: {
      username: {
        type: 'string',
        minLength: 8
      },
      password: {
        type: 'string',
        minimum: 8,
        maximum: 64
      }
    },
    additionalProperties: false
  }.freeze
end
