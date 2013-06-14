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

module.exports = Model
