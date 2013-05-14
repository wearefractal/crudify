getRoutesFromModel = require "./util/getRoutesFromModel"
async = require 'async'
hookify = require 'hookify'

class Model extends hookify
  constructor: (@_model) ->
    super
    @updateRoutes()
    @_middleware = []

  updateRoutes: ->
    @routes = getRoutesFromModel @_model
    return @

  use: (fn) ->
    @pre 'handle', fn
    return @

  unuse: (fn) ->
    @removePre 'handle', fn
    return @

module.exports = Model