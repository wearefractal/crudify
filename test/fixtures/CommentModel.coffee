{Schema} = mongoose = require 'mongoose'
{ ObjectId } = Schema.Types

Model = new Schema
  
  user:
    type: ObjectId
    ref: "User"

  body:
    type: String
  
  created_at:
    type: Date
    default: Date.now

  updated_at: Date

Model.pre "save", (next) ->
  @updated_at = Date.now()
  next()

Model.statics.authorize = (req) ->
  permission =
    read: (req.get('hasRead') isnt 'false')
    write: (req.get('hasWrite') isnt 'false')
    delete: (req.get('hasDelete') isnt 'false')
  return permission

module.exports = Model
