{Schema} = mongoose = require 'mongoose'

UserModel = new Schema

  name:
    type: String
    required: true

  password:
    type: String
    authorize: (req, cb) ->
      console.log req
      cb()

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

UserModel.statics.search = (opt, cb) -> cb null, {query: opt.q}
UserModel.methods.findWithSameName = (opt, cb) ->  cb null, {name: @name, query: opt.q}

module.exports = UserModel