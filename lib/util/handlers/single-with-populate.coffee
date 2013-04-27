extendQueryFromParams = require '../extendQueryFromParams'
executeAndSendQuery = require '../executeAndSendQuery'
sendError = require '../sendError'
getAllPaths = require '../getAllPaths'

module.exports = (route) ->
  [Model, SubModel] = route.meta.models
  toPopulate = route.meta.field
  out = {}
    
  out.get = (req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    firstQuery = Model.findById singleId
    firstQuery.select "-#{k}" for k in getAllPaths(Model, false) when k isnt toPopulate
    firstQuery.exec (err, data) ->
      return sendError res, err if err?
      query = SubModel.findById data[toPopulate]
      query = extendQueryFromParams query, req.query
      executeAndSendQuery query, res

  ###
  out.put = (req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'string'
    singleId = req.params[route.meta.primaryKey]
    updates = $set: {}
    updates.$set[toPopulate] = req.body

    query = Model.findByIdAndUpdate singleId, $set: req.body
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  out.delete = (req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    updates = $unset: {}
    updates.$unset[toPopulate] = 1

    query = Model.findByIdAndUpdate singleId, updates
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res
  ###
  
  delete out[k] for k,v of out when !(k in route.methods) # adhere to given limits
  return out