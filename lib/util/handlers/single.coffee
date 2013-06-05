extendQueryFromParams = require '../extendQueryFromParams'
sendError = require '../sendError'
sendResult = require '../sendResult'
getAllPaths = require '../getAllPaths'
filterDocument = require '../filterDocument'
defaultPerms = require '../defaultPerms'
execQuery = require '../execQuery'
getDefault = require '../getDefault'

module.exports = (route) ->
  [Model] = route.meta.models
  out = {}

  out.get = (model, req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query, route.meta
    execQuery.bind(@) model, req, res, query, (err, mod) =>
      return sendError res, err if err?
      return sendError res, "Not found", 404 unless mod?
      perms = (if mod.authorize then mod.authorize(req) else defaultPerms)
      return sendError res, "Not authorized", 401 unless perms.read is true
      nMod = filterDocument req, mod
      return sendResult.bind(@) model, req, res, nMod

  out.put = (model, req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'object'
    delete req.body._id
    delete req.body.__v
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query, route.meta
    execQuery.bind(@) model, req, res, query, (err, mod) =>
      return sendError res, err if err?
      return sendError res, "Not found", 404 unless mod?
      perms = (if mod.authorize then mod.authorize(req) else defaultPerms)
      return sendError res, "Not authorized", 401 unless perms.read is true
      return sendError res, "Not authorized", 401 unless perms.write is true
      
      for k in getAllPaths Model
        if mod.schema.paths[k].options?.authorize?
          toCall = mod.schema.paths[k].options.authorize.bind mod
          perms = toCall req
          if req.body[k]? # they explicitly tried to PUT a change on a non-writable field
            return sendError res, "Not authorized", 401 unless perms.read is true
            return sendError res, "Not authorized", 401 unless perms.write is true
          continue unless perms.read is true
          continue unless perms.write is true

        mod.set k, getDefault(mod, k)

      mod.set req.body

      mod.save (err, nMod) =>
        return sendError res, err if err?
        return sendResult.bind(@) model, req, res, mod

  out.patch = (model, req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'object'
    delete req.body._id
    delete req.body.__v
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query, route.meta
    execQuery.bind(@) model, req, res, query, (err, mod) =>
      return sendError res, err if err?
      return sendError res, "Not found", 404 unless mod?
      perms = (if mod.authorize then mod.authorize(req) else defaultPerms)
      return sendError res, "Not authorized", 401 unless perms.read is true
      return sendError res, "Not authorized", 401 unless perms.write is true
      
      for k,v of req.body when (k in getAllPaths(Model))
        if mod.schema.paths[k].options?.authorize?
          toCall = mod.schema.paths[k].options.authorize.bind mod
          perms = toCall req
          return sendError res, "Not authorized", 401 unless perms.read is true
          return sendError res, "Not authorized", 401 unless perms.write is true

        mod.set k, v

      mod.save (err, nMod) =>
        return sendError res, err if err?
        return sendResult.bind(@) model, req, res, mod

  out.delete = (model, req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    execQuery.bind(@) model, req, res, query, (err, mod) =>
      return sendError res, err if err?
      return sendError res, "Not found", 404 unless mod?
      perms = (if mod.authorize then mod.authorize(req) else defaultPerms)
      return sendError res, "Not authorized", 401 unless perms.read is true
      return sendError res, "Not authorized", 401 unless perms.write is true
      return sendError res, "Not authorized", 401 unless perms.delete is true
      
      mod.remove (err) =>
        return sendError res, err if err?
        return sendResult.bind(@) model, req, res, mod

  return out