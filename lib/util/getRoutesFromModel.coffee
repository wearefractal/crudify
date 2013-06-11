getPopulatesFromModel = require "./getPopulatesFromModel"
getStaticsFromModel = require "./getStaticsFromModel"
getInstanceMethodsFromModel = require "./getInstanceMethodsFromModel"

reserved = ['authorize']

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
    methods: ["post","get"]
    path: "/#{collectionName}"

  # static methods
  statics = getStaticsFromModel model
  for name, fn of statics when !(name in reserved)
    routes.push
      meta:
        type: "collection-static-method"
        models: [model]
        handlerName: name
        handler: fn
      methods: ["post","get"]
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
    methods: ["get","put","patch","delete"]
    path: "/#{collectionName}/:#{primaryKey}"

  # instance methods
  instMethods = getInstanceMethodsFromModel model
  for name, fn of instMethods when !(name in reserved)
    routes.push
      meta:
        type: "single-instance-method"
        models: [model]
        handlerName: name
        handler: fn
        primaryKey: primaryKey
      methods: ["post","get"]
      path: "/#{collectionName}/:#{primaryKey}/#{name}"

  # sub-items
  toPopulate = getPopulatesFromModel model
  for path in toPopulate
    fieldName = path.name
    actualModel = model.db.model path.modelName
    nestedModelName = actualModel.modelName
    secondaryKey = "#{fieldName}#{nestedModelName}Id"

    # GET returns the populated field
    routes.push
      meta:
        type: "single-with-populate"
        models: [model, actualModel]
        field: fieldName
        primaryKey: primaryKey
      methods: ["get"]
      path: "/#{collectionName}/:#{primaryKey}/#{fieldName}"

    if path.plural
      # POST adds a new DBRef to the list
      routes.push
        meta:
          type: "single-with-populate-many"
          models: [model, actualModel]
          field: fieldName
          primaryKey: primaryKey
        methods: ["post"]
        path: "/#{collectionName}/:#{primaryKey}/#{fieldName}"

      # DELETE will delete the DBRef from the list
      ###
      routes.push
        meta:
          type: "single-with-populate-many"
          models: [model, actualModel]
          field: fieldName
          primaryKey: primaryKey
          secondaryKey: secondaryKey
        methods: ["delete"]
        path: "/#{collectionName}/:#{primaryKey}/#{fieldName}/:#{secondaryKey}"
      ###

  return routes