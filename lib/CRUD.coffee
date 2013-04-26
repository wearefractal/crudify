getRoutesFromModel = require "./getRoutesFromModel"

class CRUD
  constructor: (@db) ->

  expose: (model) ->
    model = @db.model model
    throw new Error "Model #{model} is not defined" unless model?
    routesToAdd = getRoutesFromModel model
    console.log routesToAdd
    return @

  middleware: ->
    fn = (req, res, next) ->
      next()
    return fn

module.exports = CRUD