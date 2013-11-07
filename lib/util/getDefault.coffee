module.exports = (model, field) ->
  def = model.schema.tree[field].default
  return unless def?

  if typeof def is 'function'
    return def.bind(model)()
  else
    return def