extendQueryFromParams = require './extendQueryFromParams'
sendError = require './sendError'
sendResult = require './sendResult'
sendResultStream = require './sendResultStream'
executeAndSendQuery = require './executeAndSendQuery'

createCollectionHandler = (route) ->
  [Model] = route.meta.models
  out = {}
    
  out.get = (req, res, next) ->
    query = Model.find()
    query = extendQueryFromParams query, req.query
    # TODO: call middleware
    executeAndSendQuery query, res, next

  out.post = (req, res, next) ->
    delete req.body._id
    query = Model.create req.body
    query = extendQueryFromParams query, req.query
    # TODO: call middleware
    executeAndSendQuery query, res, next

  delete out[k] for k,v of out when !(k in route.methods) # adhere to given limits
  return out

createSingleHandler = (route) ->
  [Model] = route.meta.models
  out = {}
    
  out.get = (req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query
    # TODO: call middleware
    executeAndSendQuery query, res, next

  # TODO: actually make a put
  out.put = out.patch = (req, res, next) ->
    delete req.body._id
    singleId = req.params[route.meta.primaryKey]
    query = Model.findByIdAndUpdate singleId, $set: req.body
    query = extendQueryFromParams query, req.query
    # TODO: call middleware
    executeAndSendQuery query, res, next

  out.delete = (req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findByIdAndRemove singleId
    query = extendQueryFromParams query, req.query
    # TODO: call middleware
    executeAndSendQuery query, res, next

  delete out[k] for k,v of out when !(k in route.methods) # adhere to given limits
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