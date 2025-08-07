def retrieve_authors
  authors_content = File.read('AUTHORS')

  res.status = 200
  res.json({ authors: authors_content })
end
