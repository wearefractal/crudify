extendQueryFromParams = require '../extendQueryFromParams'
sendError = require '../sendError'
sendResult = require '../sendResult'
getAllPaths = require '../getAllPaths'
filterDocument = require '../filterDocument'
defaultPerms = require '../defaultPerms'
execQuery = require '../execQuery'

module.exports = (route) ->
  [Model] = route.meta.models
  out = {}

  out.get = (model, req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query
    query.populate route.meta.field
    execQuery.bind(@) model, req, res, query, (err, mod) =>
      return sendError res, err if err?
      return sendError res, "Not found", 404 unless mod?
      perms = (if mod.authorize then mod.authorize(req) else defaultPerms)
      return sendError res, "Not authorized", 401 unless perms.read is true
      nMod = filterDocument(req, mod)[route.meta.field]
      return sendError res, "Not authorized", 401 unless nMod?
      return sendResult.bind(@) model, req, res, nMod

  return out