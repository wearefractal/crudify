crudify = require '../'
should = require 'should'
{Schema} = mongoose = require 'mongoose'
require 'mocha'

UserModel = new Schema
  name:
    type: String
    required: true

  bestFriend:
    type: Schema.Types.ObjectId
    ref: 'User'

  friends: [
    type: Schema.Types.ObjectId
    ref: 'User'
  ]

describe 'crudify', ->
  describe 'crudify()', ->
    it 'should produce the right object', (done) ->
      crud = crudify()
      should.exist crud
      done()

  describe 'middleware()', ->
    it 'should produce the right object', (done) ->
      crud = crudify()
      middle = crud.middleware()
      should.exist middle
      middle.length.should.equal 3
      done()

  describe 'scanModelTree()', ->
    it 'should add a model and its routes', (done) ->
      db = mongoose.createConnection()
      model = db.model 'User', UserModel
      toPopulate = crudify.scanModelTree model
      expected = [
        name: "bestFriend"
        plural: false
        single: true
      ,
        name: "friends"
        plural: true
        single: false
      ]
      toPopulate.should.eql expected
      done()

  describe 'expose()', ->
    it 'should add a model and its routes', (done) ->
      db = mongoose.createConnection()
      db.model 'User', UserModel
      crud = crudify db

      crud.expose 'User'

      done()