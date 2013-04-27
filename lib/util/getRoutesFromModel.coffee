getPopulatesFromModel = require "./getPopulatesFromModel"

module.exports = (model) ->
  routes = []
  collectionName = model.collection.name
  modelName = model.modelName
  lowerModelName = modelName.toLowerCase()

  # collection level
  # GET lists all items in the collection
  # POST creates a new item in the collection
  routes.push
    models: [model]
    methods: ["get","post"]
    path: "/#{collectionName}"

  # specific item
  # GET returns the object from the collection
  # PUT replaces the object in the collection
  # PATCH modifies the object in the collection
  # DELETe removes the object from the collection
  routes.push
    models: [model]
    methods: ["get","put","patch","delete"]
    path: "/#{collectionName}/:#{lowerModelName}Id"

  # sub-items
  toPopulate = getPopulatesFromModel model
  for path in toPopulate
    name = path.name
    actualModel = model.db.model path.modelName
    nestedModelName = actualModel.modelName

    if path.single
      routes.push
        models: [model, actualModel]
        methods: ["get","put","delete"]
        path: "/#{collectionName}/:#{lowerModelName}Id/#{name}"
      continue

    if path.plural
      # GET returns list of DBRefs
      # POST adds a new DBRef to the list
      routes.push
        models: [model, actualModel]
        methods: ["get","post"]
        path: "/#{collectionName}/:#{lowerModelName}Id/#{name}"

      # GET returns the full model populated from the list of DBRefs
      # DELETE will delete the DBRef from the list
      routes.push
        models: [model, actualModel]
        methods: ["get","delete"]
        path: "/#{collectionName}/:#{lowerModelName}Id/#{name}/:#{name}#{nestedModelName}Id"

  return routes