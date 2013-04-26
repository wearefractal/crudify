scanModelTree = require "./scanModelTree"

module.exports = (model) ->
  routes = []
  collectionName = model.collection.name

  # collection level
  routes.push
    methods: ["get","post"]
    path: "/#{collectionName}"

  # specific item
  routes.push
    methods: ["get","put","patch","delete"]
    path: "/#{collectionName}/:id"

  # sub-items
  toPopulate = scanModelTree model
  for path in toPopulate
    name = path.name

    methods = ["get","put","patch","delete"]
    methods.push "post" if path.plural
    
    routes.push
      methods: methods
      path: "/#{collectionName}/:id/#{name}"

  return routes