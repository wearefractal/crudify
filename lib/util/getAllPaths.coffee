module.exports = (model, includeAll) ->
  return Object.keys(model.schema.tree) if includeAll
  paths = []
  for k,v of model.schema.tree
    continue if k is model.schema.options.versionKey
    continue if k is 'id' and model.schema.options.id is true
    continue if k is '_id' and model.schema.options._id is true
    paths.push k
  return paths