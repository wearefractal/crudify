extendQueryFromParams = require '../extendQueryFromParams'
sendError = require '../sendError'
sendResult = require '../sendResult'
defaultPerms = require '../defaultPerms'
execQuery = require '../execQuery'

module.exports = (route) ->
  [Model] = route.meta.models
  handlerName = route.meta.handlerName
  out = {}
  
  doIt = (model, req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query, route.meta
    execQuery.bind(@) model, req, res, query, (err, mod) =>
      return sendError res, err if err?
      return sendError res, "Not found", 404 unless mod?
      perms = (if mod.authorize then mod.authorize(req) else defaultPerms)
      return sendError res, "Not authorized", 401 unless perms.read is true
      mod[handlerName] req, (err, dat) =>
        return sendError res, err if err?
        sendResult.bind(@) model, req, res, dat

  out.get = doIt
  out.post = doIt
  out.patch = doIt
  out.delete = doIt
  return out