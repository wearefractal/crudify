sendError = require '../sendError'
sendResult = require '../sendResult'

module.exports = (route) ->
  [Model] = route.meta.models
  staticMethod = route.meta.handler
  out = {}
  
  out.get = (req, res, next) ->
    staticMethod req.query, (err, data) ->
      return sendError res, err if err?
      sendResult res, data

  out.post = (req, res, next) ->
    staticMethod req.body, (err, data) ->
      return sendError res, err if err?
      sendResult res, data

  delete out[k] for k,v of out when !(k in route.methods) # adhere to given limits
  return out