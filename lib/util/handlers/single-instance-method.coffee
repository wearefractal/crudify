extendQueryFromParams = require '../extendQueryFromParams'
sendError = require '../sendError'
sendResult = require '../sendResult'
defaultPerms = require '../defaultPerms'

module.exports = (route) ->
  [Model] = route.meta.models
  handlerName = route.meta.handlerName
  out = {}
  
  out.get = (req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query
    query.exec (err, mod) ->
      return sendError res, err if err?
      perms = (if mod.authorize then mod.authorize(req) else defaultPerms)
      return sendError res, "Not authorized" unless perms.read is true
      mod[handlerName] req.query, (err, dat) ->
        return sendError res, err if err?
        sendResult res, dat

  out.post = (req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'object'
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query
    query.exec (err, mod) ->
      return sendError res, err if err?
      perms = (if mod.authorize then mod.authorize(req) else defaultPerms)
      return sendError res, "Not authorized" unless perms.read is true
      mod[handlerName] req.body, (err, dat) ->
        return sendError res, err if err?
        sendResult res, dat

  return out