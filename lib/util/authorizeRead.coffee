defaultPerms = require "./defaultPerms"
getDefault = require './getDefault'
getAllPaths = require './getAllPaths'
getRestricted = require './getRestrictedFromModel'
async = require 'async'

filterModel = (mod, args, cb) ->
  out = mod.toJSON()

  filterField = (path, done) ->
    callAuthorize path.handler, mod, args, (fieldPerms) ->
      delete out[path.name] unless fieldPerms.read is true
      done()

  async.forEach getRestricted(mod), filterField, -> cb out

callAuthorize = (fn, scope, args, cb) ->
  if typeof fn is 'function'
    fnPerms = fn.bind(scope) args..., cb
    cb fnPerms if fnPerms? and (fnPerms.read? or fnPerms.write? or fnPerms.delete?)
  else
    cb defaultPerms

module.exports = ({args, collection, model, models}, cb) ->

  authCollection = (done) ->
    callAuthorize collection.authorize, collection, args, (collectionPerms) ->
      return done (collectionPerms.read is true)

  modelLegit = (mod, done) ->
    callAuthorize mod.authorize, mod, args, (instancePerms) ->
      return done false unless instancePerms.read is true
      return done true

  filterModelHak = (mod, done) ->
    filterModel mod, args, (nMod) -> 
      done null, nMod

  authModel = (done) ->
    if model?
      modelLegit model, (legit) ->
        return done false unless legit is true
        filterModel model, args, (filteredModel) ->
          done true, filteredModel

    else if models?
      async.filter models, modelLegit, (legitModels) ->
        async.map legitModels, filterModelHak, (_, filteredModels) ->
          done true, filteredModels

  if collection?
    authCollection (isGood) ->
      return cb false unless isGood is true
      return cb true unless model? or models?
      authModel cb
  else
    authModel cb