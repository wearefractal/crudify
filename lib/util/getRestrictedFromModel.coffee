module.exports = (model) ->
  out = []
  for name, path of model.schema.tree when path.authorize?
    out.push
      name: name
      handler: path.authorize
  return out