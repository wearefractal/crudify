extendQueryFromParams = require '../extendQueryFromParams'
executeAndSendQuery = require '../executeAndSendQuery'

module.exports = (route) ->
  [Model] = route.meta.models
  out = {}
    
  out.get = (req, res, next) ->
    query = Model.find()
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  out.post = (req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'object'
    delete req.body._id
    delete req.body.__v
    query = Model.create req.body
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  delete out[k] for k,v of out when !(k in route.methods) # adhere to given limits
  return out