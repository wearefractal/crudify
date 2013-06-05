cloneQuery = require './cloneQuery'
formatParams = require './formatParams'

reserved = ["skip","limit","sort","populate"]

module.exports = (origQuery, origParams={}, meta) ->
  query = cloneQuery origQuery
  params = formatParams origParams, query.model

  if meta.field?
    query.populate
      path: meta.field
      match: params.conditions
      options:
        limit: params.limit
        skip: params.skip
        sort: params.sort
    query.populate "#{meta.field}.#{field}" for field in params.populate if params.populate?
    
  else
    if meta.type is 'collection'
      query.skip params.skip if params.skip?
      query.limit params.limit if params.limit?
      query.where k, v for k,v of params.conditions if params.conditions?
      query.sort field for field in params.sort if params.sort?

    query.populate field for field in params.populate if params.populate?
  
  return query