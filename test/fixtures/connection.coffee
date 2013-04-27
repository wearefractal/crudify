mongoose = require 'mongoose'
UserModel = require './UserModel'

db = mongoose.createConnection()
db.model 'User', UserModel

module.exports = db