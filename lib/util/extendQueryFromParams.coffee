cloneQuery = require './cloneQuery'
formatParams = require './formatParams'

reserved = ["skip","limit","sort","populate"]

module.exports = (origQuery, origParams={}, parentField) ->
  query = cloneQuery origQuery
  params = formatParams origParams, query.model

  if parentField?
    query.populate
      path: parentField
      match: params.conditions
      #options: query.options
    query.populate "#{parentField}.#{field}" for field in params.populate if params.populate?
    
  else
    if query.op isnt 'findOne'
      query.skip params.skip if params.skip?
      query.limit params.limit if params.limit?
      query.where k, v for k,v of params.conditions if params.conditions?

    query.sort field for field in params.sort if params.sort?
    query.populate field for field in params.populate if params.populate?
  
  return query