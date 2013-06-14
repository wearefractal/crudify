sendError = require '../sendError'
sendResult = require '../sendResult'
authorizeRead = require "../authorizeRead"

module.exports = (route) ->
  [Model] = route.meta.models
  handlerName = route.meta.handlerName
  out = {}
  
  doIt = (model, req, res, next) ->
    authorizeRead {collection:Model,args:[req]}, (canReadCollection) =>
      return sendError res, "Not authorized", 401 unless canReadCollection
      Model[handlerName] req, (err, data) =>
        return sendError res, err if err?
        sendResult.bind(@) model, req, res, data

  out.get = doIt
  out.post = doIt
  out.patch = doIt
  out.delete = doIt
  return out
