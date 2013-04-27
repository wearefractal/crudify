module.exports = (model, name) ->
  # TODO: support nested field by looking up the model
  return model.schema.paths[name]?