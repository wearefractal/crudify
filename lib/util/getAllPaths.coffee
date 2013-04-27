module.exports = (model, includeAll) ->
  return Object.keys(model.schema.paths) if includeAll
  paths = []
  for k,v of model.schema.paths
    continue if k is model.schema.options.versionKey
    continue if k is '_id' and model.schema.options._id is true
    paths.push k
  return paths