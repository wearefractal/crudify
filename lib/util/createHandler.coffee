extendQueryFromParams = require './extendQueryFromParams'
sendError = require './sendError'
sendResult = require './sendResult'
sendResultStream = require './sendResultStream'
executeAndSendQuery = require './executeAndSendQuery'

createCollectionHandler = (route) ->
  [Model] = route.meta.models
  out = (req, res, next) ->
    query = Model.find()
    query = extendQueryFromParams query, req.query
    # TODO: call middleware
    executeAndSendQuery query, res, next
  return out

module.exports = (route) ->
  type = route.meta.type

  return createCollectionHandler route if type is 'collection'
  return createSingleHandler route if type is 'single'
  return createStaticHandler route if type is 'collection-static-method'
  return createInstanceHandler route if type is 'single-instance-method'
  return createSingleWithPopulateHandler route if type is 'single-with-populate'
  return createSingleWithPopulateMany route if type is 'single-with-populate-many'
  return