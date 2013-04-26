module.exports = (model) ->
  out = []
  for name, path of model.schema.paths
    isSingle = path.options?.ref?
    isPlural = path.caster?.options?.ref?
    continue unless isSingle or isPlural
    out.push
      name: name
      plural: isPlural
      single: isSingle
  return out