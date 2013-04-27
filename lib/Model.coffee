getRoutesFromModel = require "./util/getRoutesFromModel"

class Model
  constructor: (@_model) ->
    @updateRoutes()
    @_middleware = []

  updateRoutes: ->
    @routes = getRoutesFromModel @_model
    return @

  use: (fn) ->
    @_middleware.push fn
    return @
    
  runMiddleware: (a..., cb) ->
    return cb() unless @_middleware.length isnt 0
    run = (middle, done) => middle a..., done
    async.forEachSeries @_middleware, run, cb
    return

module.exports = Model