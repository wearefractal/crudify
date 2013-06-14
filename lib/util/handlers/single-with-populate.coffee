extendQueryFromParams = require '../extendQueryFromParams'
sendError = require '../sendError'
sendResult = require '../sendResult'
execQuery = require '../execQuery'
authorizeRead = require '../authorizeRead'

module.exports = (route) ->
  [Model] = route.meta.models
  out = {}

  out.get = (model, req, res, next) ->
    authorizeRead {collection:Model,args:[req]}, (canReadCollection) =>
      return sendError res, "Not authorized", 401 unless canReadCollection

      singleId = req.params[route.meta.primaryKey]
      query = Model.findById singleId
      query = extendQueryFromParams query, req.query, route.meta
      execQuery.bind(@) model, req, res, query, (err, mod) =>
        return sendError res, err if err?
        return sendError res, "Not found", 404 unless mod?
        authorizeRead {model:mod,args:[req]}, (canReadModel, nMod) =>
          return sendError res, "Not authorized", 401 unless canReadModel

          nMod = nMod[route.meta.field]
          return sendError res, "Not authorized", 401 unless nMod?
          return sendResult.bind(@) model, req, res, nMod

  return out