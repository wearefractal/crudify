getAllPaths = require './getAllPaths'
async = require 'async'

module.exports = (req, mod) ->
  for k in getAllPaths(mod) when mod.schema.tree[k].authorize?
    toCall = mod.schema.tree[k].authorize.bind mod
    perms = toCall req
    mod.set k, undefined unless perms.read is true

  return mod