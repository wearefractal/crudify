{Schema} = mongoose = require 'mongoose'

UserModel = new Schema

  name:
    type: String
    required: true

  password:
    type: String
    default: "pass123"
    authorize: (req) ->
      permission =
        read: false
        write: false
      return permission

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

UserModel.statics.authorize = (req) ->
  permission =
    read: (req.get('hasRead') isnt 'false')
    write: (req.get('hasWrite') isnt 'false')
    delete: (req.get('hasDelete') isnt 'false')
  return permission

UserModel.methods.authorize = (req) ->
  permission =
    read: (req.get('hasRead') isnt 'false')
    write: (req.get('hasWrite') isnt 'false')
    delete: (req.get('hasDelete') isnt 'false')
  return permission

module.exports = UserModel