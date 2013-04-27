requireDir = require 'require-directory'
{join} = require 'path'

CRUD = require './CRUD'
Model = require './Model'

mod = (db) -> new CRUD db

# Expose for extending
mod.CRUD = CRUD
mod.Model = Model

# Expose for testing
mod.util = requireDir module, join __dirname, './util'

module.exports = mod