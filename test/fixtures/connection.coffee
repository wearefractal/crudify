mongoose = require 'mongoose'
async = require 'async'
UserModel = require './UserModel'

db = mongoose.createConnection "mongodb://localhost/crudify-test"
db.model 'User', UserModel

db.wipe = (cb) ->
  async.parallel (m.remove.bind m for _, m of db.models), cb
  return db

module.exports = db