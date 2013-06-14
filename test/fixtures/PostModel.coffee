{Schema} = mongoose = require 'mongoose'
{ ObjectId } = Schema.Types

Model = new Schema
  
  title:
    type: String
    required: true

  user:
    type: ObjectId
    ref: "User"

  created_at:
    type: Date
    default: Date.now

  updated_at: Date

  body:
    type: String

  comments: [
    type: ObjectId
    ref: "Comment"
  ]

Model.pre "save", (next) ->
  @updated_at = Date.now()
  next()

module.exports = Model
