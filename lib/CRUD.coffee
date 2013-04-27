Model = require "./Model"
createHandler = require "./util/createHandler"
async = require 'async'

class CRUD
  constructor: (@db) ->
    throw new Error "Missing db argument" unless @db?
    @_models = {}
    @_middleware = []

  expose: (modelName) ->
    throw new Error "modelName argument needs to be a string" unless typeof modelName is 'string'
    throw new Error "#{modelName} is already exposed" if @_models[modelName]?
    model = @db.model modelName
    throw new Error "#{modelName} is not defined in the databse" unless model?
    @_models[modelName] = new Model model
    return @_models[modelName]

  unexpose: (modelName) ->
    throw new Error "modelName argument needs to be a string" unless typeof modelName is 'string'
    throw new Error "#{modelName} is not exposed" unless @_models[modelName]?
    # TODO: actually unwire stuff
    delete @_models[modelName]
    return @

  get: (modelName) ->
    throw new Error "modelName argument needs to be a string" unless typeof modelName is 'string'
    return @_models[modelName]

  use: (fn) ->
    @_middleware.push fn
    return @
    
  runMiddleware: (a..., cb) =>
    return cb() unless @_middleware.length isnt 0
    run = (middle, done) => middle a..., done
    async.forEachSeries @_middleware, run, cb
    return

  hook: (path, app) ->
    if typeof path isnt 'string'
      app = path
      path = null
    throw new Error "Missing httpServer" unless app?
    for name, model of @_models
      for route in model.routes
        handler = createHandler route
        for method, fn of handler
          p = (if path then path+route.path else route.path)
          app[method] p, @runMiddleware, model.runMiddleware, fn
    return @

module.exports = CRUD