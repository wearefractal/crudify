sendError = require '../sendError'
sendResult = require '../sendResult'
defaultPerms = require "../defaultPerms"

module.exports = (route) ->
  [Model] = route.meta.models
  handlerName = route.meta.handlerName
  out = {}
  
  doIt = (model, req, res, next) ->
    perms = (if Model.authorize then Model.authorize(req) else defaultPerms)
    return sendError res, "Not authorized", 401 unless perms.read is true
    Model[handlerName] req, (err, data) ->
      return sendError res, err if err?
      sendResult res, data

  out.get = doIt
  out.post = doIt
  out.patch = doIt
  out.delete = doIt
  return out
