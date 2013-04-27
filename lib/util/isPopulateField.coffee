module.exports = (name, path) ->
  singleName = path.options?.ref
  pluralName = path.caster?.options?.ref
  return false unless singleName? or pluralName?
  out =
    name: name
    single: singleName?
    plural: pluralName?
    modelName: (singleName or pluralName)
  return out