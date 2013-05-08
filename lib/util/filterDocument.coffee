getAllPaths = require './getAllPaths'
async = require 'async'

module.exports = (req, mod) ->
  out = mod.toJSON()

  for k in getAllPaths(mod) when mod.schema.paths[k].authorize?
    toCall = mod.schema.paths[k].authorize.bind mod
    perms = toCall req
    delete out[k] unless perms.read is true

  return mod