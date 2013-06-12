extendQueryFromParams = require '../extendQueryFromParams'
sendError = require '../sendError'
sendResult = require '../sendResult'
getAllPaths = require '../getAllPaths'
filterDocument = require '../filterDocument'
defaultPerms = require '../defaultPerms'
execQuery = require '../execQuery'
getDefault = require '../getDefault'
{Schema} = require 'mongoose'

isObjectId = (str) -> str? and (str.length is 12 or str.length is 24)

module.exports = (route) ->
  [Model] = route.meta.models
  out = {}

  out.post = (model, req, res, next) ->
    return sendError res, "Invalid body" unless typeof req.body is 'object'
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query, route.meta
    query.populate route.meta.field
    execQuery.bind(@) model, req, res, query, (err, mod) =>
      return sendError res, err if err?
      return sendError res, "Not found", 404 unless mod?
      perms = (if mod.authorize then mod.authorize(req) else defaultPerms)
      return sendError res, "Not authorized", 401 unless perms.read is true
      nMod = filterDocument(req, mod)
      return sendError res, "Not authorized", 401 unless nMod[route.meta.field]?

      delete req.body._id
      delete req.body.__v

      Model.create req.body, (err, data) =>
        return sendError res, err if err?
        nMod[route.meta.field].push String data._id
        nMod.save (err, resMod) =>
          return sendError res, err if err?
          return sendResult.bind(@) model, req, res, resMod[route.meta.field]


  out.put = (model, req, res, next) ->
    return sendError res, "Invalid body" unless typeof req.body is 'object'
    return sendError res, "Invalid ObjectId" unless isObjectId String req.body._id
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query, route.meta
    query.populate route.meta.field

    execQuery.bind(@) model, req, res, query, (err, mod) =>
      return sendError res, err if err?
      return sendError res, "Not found", 404 unless mod?
      perms = (if mod.authorize then mod.authorize(req) else defaultPerms)
      return sendError res, "Not authorized", 401 unless perms.read is true
      nMod = filterDocument(req, mod)
      return sendError res, "Not authorized", 401 unless nMod[route.meta.field]?
      nMod[route.meta.field].push String req.body._id
      nMod.save (err, resMod) =>
        return sendError res, err if err?
        return sendResult.bind(@) model, req, res, resMod[route.meta.field]

  return out