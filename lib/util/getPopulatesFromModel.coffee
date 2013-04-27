isPopulateField = require './isPopulateField'

module.exports = (model) ->
  out = []
  for name, path of model.schema.paths
    scan = isPopulateField name, path
    out.push scan if scan
  return out