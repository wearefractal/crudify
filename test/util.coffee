{util} = crudify = require '../'
should = require 'should'
require 'mocha'

db = require './fixtures/connection'
User = db.model 'User'

describe 'crudify utils', ->
  describe 'getPopulatesFromModel()', ->
    it 'should add a model and its routes', (done) ->
      toPopulate = util.getPopulatesFromModel User
      expected = [
        name: "bestFriend"
        plural: false
        single: true
        modelName: "User"
      ,
        name: "friends"
        plural: true
        single: false
        modelName: "User"
      ]
      toPopulate.should.eql expected
      done()

  describe 'hasField()', ->
    it 'should return true on valid field', (done) ->
      util.hasField(User, 'name').should.equal true
      done()

    it 'should return false on invalid field', (done) ->
      util.hasField(User, 'blah').should.equal false
      done()

  describe 'getRoutesFromModel()', ->
    it 'should return the right routes', (done) ->
      routes = util.getRoutesFromModel User
      console.log routes
      done()