Model = require "./Model"
async = require 'async'
{join} = require 'path'
hookify = require 'hookify'

class CRUD extends hookify
  constructor: (@db) ->
    super
    throw new Error "Missing db argument" unless @db?
    @_models = {}

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
    delete @_models[modelName]
    return @

  get: (modelName) ->
    throw new Error "modelName argument needs to be a string" unless typeof modelName is 'string'
    return @_models[modelName]

  use: (fn) ->
    @pre 'handle', fn
    return @

  unuse: (fn) ->
    @removePre 'handle', fn
    return @

  _hookRoute: (path, app, model, route) =>
    handler = require("./util/handlers/#{route.meta.type}") route
    p = (if path? then join(path,route.path) else route.path)
    
    checkExists = (req, res, next) =>
      return unless @_models[model.name]?
      next()

    modelPre = (req, res, next) =>
      model.runPre 'handle', [req,res], next
    modelPost = (req, res, next) =>
      model.runPost 'handle', [req,res], next
    
    thisPre = (req, res, next) =>
      @runPre 'handle', [req,res], next
    thisPost = (req, res, next) =>
      @runPost 'handle', [req,res], next
    
    attachMeta = (req, res, next) =>
      req.meta = route
      next()

    for method, fn of handler
      app[method] p, checkExists, attachMeta,
        thisPre, modelPre, 
        fn.bind(@, model), 
        thisPost, modelPost
    return @

  _sendMeta: (req, res, next) =>
    out = collections: []

    for name, model of @_models
      nRoute =
        name: model._model.collection.name
        routes: []

      for route in model.routes
        nRoute.routes.push
          type: route.meta.type
          methods: route.methods
          url: route.path

      out.collections.push nRoute

    res.json 200, out

  hook: (path, app) ->
    if typeof path isnt 'string'
      app = path
      path = null
    throw new Error "Missing httpServer" unless app?
    for name, model of @_models
      for route in model.routes
        @_hookRoute path, app, model, route

    rootPath = (if path? then join(path,"/") else "/")
    app.get rootPath, @_sendMeta
    return @

module.exports = CRUD