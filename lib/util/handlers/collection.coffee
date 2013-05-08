extendQueryFromParams = require '../extendQueryFromParams'
sendError = require '../sendError'
sendResult = require '../sendResult'
sendResultStream = require '../sendResultStream'
defaultPerms = require '../defaultPerms'

module.exports = (route) ->
  [Model] = route.meta.models
  out = {}
    
  out.get = (req, res, next) ->
    perms = (if Model.authorize then Model.authorize(req) else defaultPerms)
    return sendError res, "Not authorized" unless perms.read is true
    query = Model.find()
    query = extendQueryFromParams query, req.query
    if query.flags.stream
      stream = query.stream()
      sendResultStream res, stream
      return
  
    query.exec (err, data) ->
      return sendError res, err if err?
      return sendResult res, data

  out.post = (req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'object'
    perms = (if Model.authorize then Model.authorize(req) else defaultPerms)
    return sendError res, "Not authorized" unless perms.read is true
    return sendError res, "Not authorized" unless perms.write is true
    
    delete req.body._id
    delete req.body.__v
    Model.create req.body, (err, data) ->
      return sendError res, err if err?
      sendResult res, data
      return

  return out