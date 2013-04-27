Model = require "./Model"

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

  use: (fn) -> @_middleware.push fn
    
  middleware: ->
    fn = (req, res, next) ->
      next()
    return fn

module.exports = CRUD