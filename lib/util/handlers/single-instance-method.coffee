extendQueryFromParams = require '../extendQueryFromParams'
executeAndSendQuery = require '../executeAndSendQuery'
sendError = require '../sendError'
sendResult = require '../sendResult'

module.exports = (route) ->
  [Model] = route.meta.models
  handlerName = route.meta.handlerName
  out = {}
  
  out.get = (req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query
    query.exec (err, data) ->
      return sendError res, err if err?
      data[handlerName] req.query, (err, dat) ->
        return sendError res, err if err?
        sendResult res, dat

  out.post = (req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'object'
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query
    query.exec (err, data) ->
      return sendError res, err if err?
      data[handlerName] req.body, (err, dat) ->
        return sendError res, err if err?
        sendResult res, dat

  delete out[k] for k,v of out when !(k in route.methods) # adhere to given limits
  return out