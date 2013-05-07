extendQueryFromParams = require '../extendQueryFromParams'
executeAndSendQuery = require '../executeAndSendQuery'
sendError = require '../sendError'
sendResult = require '../sendResult'

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
    Model.create req.body, (err, data) ->
      return sendError res, err if err?
      sendResult res, data
      return

  return out