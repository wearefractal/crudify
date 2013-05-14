module.exports = (model, field) ->
  def = model.schema.paths[field].defaultValue
  return unless def?

  if typeof def is 'function'
    return def.bind(model)()
  else
    return def