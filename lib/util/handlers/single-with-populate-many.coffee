extendQueryFromParams = require '../extendQueryFromParams'
sendError = require '../sendError'
sendResult = require '../sendResult'
sendResultStream = require '../sendResultStream'
executeAndSendQuery = require '../executeAndSendQuery'

module.exports = (route) ->
  [Model] = route.meta.models
  out = {}
    
  delete out[k] for k,v of out when !(k in route.methods) # adhere to given limits
  return out