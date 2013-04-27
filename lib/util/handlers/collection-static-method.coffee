sendError = require '../sendError'
sendResult = require '../sendResult'

module.exports = (route) ->
  [Model] = route.meta.models
  staticMethod = route.meta.handler
  out = {}
  
  out.get = (req, res, next) ->
    # TODO: call middleware
    staticMethod req.query, (err, data) ->
      if err?
        sendError res, err
        next()
        return
      sendResult res, data
      next()

  out.post = (req, res, next) ->
    # TODO: call middleware
    staticMethod req.body, (err, data) ->
      if err?
        sendError res, err
        next()
        return
      sendResult res, data
      next()

  delete out[k] for k,v of out when !(k in route.methods) # adhere to given limits
  return out