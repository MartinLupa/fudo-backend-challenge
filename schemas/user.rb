module Schemas
  LOGIN_ATTEMPT = {
    type: 'object',
    required: %w[username password],
    properties: {
      username: {
        type: 'string',
        minLength: 3
      },
      password: {
        type: 'string',
        minimum: 8,
        maximum: 64
        # Add further server-side password requirements through regex.
      }
    },
    additionalProperties: false
  }.freeze
end
