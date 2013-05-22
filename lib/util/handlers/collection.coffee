extendQueryFromParams = require '../extendQueryFromParams'
sendError = require '../sendError'
sendResult = require '../sendResult'
defaultPerms = require '../defaultPerms'
execQuery = require '../execQuery'

module.exports = (route) ->
  [Model] = route.meta.models
  out = {}
    
  out.get = (model, req, res, next) ->
    perms = (if Model.authorize then Model.authorize(req) else defaultPerms)
    return sendError res, "Not authorized", 401 unless perms.read is true
    query = Model.find()
    query = extendQueryFromParams query, req.query
    execQuery.bind(@) model, req, res, query, (err, data) =>
      return sendError res, err if err?
      return sendError res, "Not found", 404 unless data?
      return sendResult.bind(@) model, req, res, data

  out.post = (model, req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'object'
    perms = (if Model.authorize then Model.authorize(req) else defaultPerms)
    return sendError res, "Not authorized", 401 unless perms.read is true
    return sendError res, "Not authorized", 401 unless perms.write is true
    
    delete req.body._id
    delete req.body.__v
    # TODO: call hooks here
    Model.create req.body, (err, data) =>
      return sendError res, err if err?
      sendResult.bind(@) model, req, res, data, 201
      return

  return out