getRoutesFromModel = require "./util/getRoutesFromModel"

class Model
  constructor: (@_model) ->
    @updateRoutes()

  updateRoutes: ->
    @routes = getRoutesFromModel @_model
    return @

module.exports = Model