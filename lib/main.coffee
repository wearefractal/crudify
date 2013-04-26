CRUD = require './CRUD'

mod = (a...) -> new CRUD a...

mod.scanModelTree = require './scanModelTree'

module.exports = mod