def handle_openapi
  openapi_spec_content = File.read('openapi.yaml')

  res.status = 200
  res.json({ openapi_spec: openapi_spec_content })
end
