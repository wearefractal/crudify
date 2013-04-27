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
    delete req.body._id
    query = Model.create req.body
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  delete out[k] for k,v of out when !(k in route.methods) # adhere to given limits
  return out