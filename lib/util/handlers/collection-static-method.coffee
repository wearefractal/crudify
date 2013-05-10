sendError = require '../sendError'
sendResult = require '../sendResult'
defaultPerms = require "../defaultPerms"

module.exports = (route) ->
  [Model] = route.meta.models
  handlerName = route.meta.handlerName
  out = {}
  
  out.get = (req, res, next) ->
    perms = (if Model.authorize then Model.authorize(req) else defaultPerms)
    return sendError res, "Not authorized" unless perms.read is true
    Model[handlerName] req.query, (err, data) ->
      return sendError res, err if err?
      sendResult res, data

  out.post = (req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'object'
    perms = (if Model.authorize then Model.authorize(req) else defaultPerms)
    return sendError res, "Not authorized" unless perms.read is true
    Model[handlerName] req.body, (err, data) ->
      return sendError res, err if err?
      sendResult res, data

  return out
