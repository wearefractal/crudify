getPopulatesFromModel = require "./getPopulatesFromModel"
getStaticsFromModel = require "./getStaticsFromModel"
getInstanceMethodsFromModel = require "./getInstanceMethodsFromModel"

module.exports = (model) ->
  routes = []
  collectionName = model.collection.name
  modelName = model.modelName
  lowerModelName = modelName.toLowerCase()
  primaryKey = "#{lowerModelName}Id"

  # collection level
  # GET lists all items in the collection
  # POST creates a new item in the collection
  routes.push
    meta:
      type: "collection"
      models: [model]
      canStream: true
    path: "/#{collectionName}"

  # static methods
  statics = getStaticsFromModel model
  for name, fn of statics
    routes.push
      meta:
        type: "collection-static-method"
        models: [model]
        handlerName: name
        handler: fn
        canStream: false
      path: "/#{collectionName}/#{name}"
      
  # specific item
  # GET returns the object from the collection
  # PUT replaces the object in the collection
  # PATCH modifies the object in the collection
  # DELETe removes the object from the collection
  routes.push
    meta:
      type: "single"
      models: [model]
      primaryKey: primaryKey
      canStream: false
    path: "/#{collectionName}/:#{primaryKey}"

  # instance methods
  instMethods = getInstanceMethodsFromModel model
  for name, fn of instMethods
    routes.push
      meta:
        type: "single-instance-method"
        models: [model]
        handlerName: name
        handler: fn
        primaryKey: primaryKey
        canStream: false
      path: "/#{collectionName}/:#{primaryKey}/#{name}"

  return routes