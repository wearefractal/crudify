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
    methods: ["get","post"]
    path: "/#{collectionName}"

  # specific item
  # GET returns the object from the collection
  # PUT replaces the object in the collection
  # PATCH modifies the object in the collection
  # DELETe removes the object from the collection
  routes.push
    meta:
      type: "single"
      models: [model]
    methods: ["get","put","patch","delete"]
    path: "/#{collectionName}/:#{primaryKey}"

  # static methods
  statics = getStaticsFromModel model
  for name, fn of statics
    routes.push
      meta:
        type: "collection-static-method"
        models: [model]
        handler: fn
      methods: ["get","post"]
      path: "/#{collectionName}/#{name}"

  # instance methods
  instMethods = getInstanceMethodsFromModel model
  for name, fn of instMethods
    routes.push
      meta:
        type: "single-instance-method"
        models: [model]
        handler: fn
      methods: ["get","post"]
      path: "/#{collectionName}/:#{primaryKey}/#{name}"

  # sub-items
  toPopulate = getPopulatesFromModel model
  for path in toPopulate
    fieldName = path.name
    actualModel = model.db.model path.modelName
    nestedModelName = actualModel.modelName
    secondaryKey = "#{fieldName}#{nestedModelName}Id"

    if path.single
      # GET returns the populated item
      # PUT replaces the DBRef with another
      # DELETE removes the DBRef
      routes.push
        meta:
          type: "single-with-populate"
          models: [model, actualModel]
          field: fieldName
        methods: ["get","put","delete"]
        path: "/#{collectionName}/:#{primaryKey}/#{fieldName}"
      continue

    if path.plural
      # GET returns list of DBRefs
      # POST adds a new DBRef to the list
      routes.push
        meta:
          type: "single-with-populate-many"
          models: [model, actualModel]
          field: fieldName
        methods: ["get","post"]
        path: "/#{collectionName}/:#{primaryKey}/#{fieldName}"

      # GET returns the full model populated from the list of DBRefs
      # DELETE will delete the DBRef from the list
      routes.push
        meta:
          type: "single-with-populate-many"
          models: [model, actualModel]
          field: fieldName
        methods: ["get","delete"]
        path: "/#{collectionName}/:#{primaryKey}/#{fieldName}/:#{secondaryKey}"

  return routes