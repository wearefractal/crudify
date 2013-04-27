{Schema} = mongoose = require 'mongoose'

UserModel = new Schema
  name:
    type: String
    required: true

  score:
    type: Number
    default: 0
    
  bestFriend:
    type: Schema.Types.ObjectId
    ref: 'User'

  friends: [
    type: Schema.Types.ObjectId
    ref: 'User'
  ]

UserModel.statics.search = (opt, cb) -> cb null, []
UserModel.methods.findWithSameName = (opt, cb) ->  cb null, []

module.exports = UserModel