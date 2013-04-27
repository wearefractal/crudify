{util} = crudify = require '../'
should = require 'should'
require 'mocha'

db = require './fixtures/connection'
User = db.model 'User'

describe 'crudify utils', ->
  describe 'getPopulatesFromModel()', ->
    it 'should return populated values', (done) ->
      toPopulate = util.getPopulatesFromModel User
      should.exist toPopulate
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

  describe 'getStaticsFromModel()', ->
    it 'should return all static methods', (done) ->
      statics = util.getStaticsFromModel User
      should.exist statics
      should.exist statics.search
      done()

  describe 'getInstanceMethodsFromModel()', ->
    it 'should return all static methods', (done) ->
      methods = util.getInstanceMethodsFromModel User
      should.exist methods
      should.exist methods.findWithSameName
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
      # TODO: finish this
      #console.log routes
      done()

  describe 'createHandler()', ->
    it 'should return valid handlers for collection', (done) ->
      route =
        meta:
          type: "collection"
          models: [User]
        methods: ["get","post"]
        path: "/users"

      handler = util.createHandler route
      should.exist handler.get
      should.exist handler.post
      handler.get.length.should.equal 3
      handler.post.length.should.equal 3
      done()

    it 'should not return excluded handlers for collection', (done) ->
      route =
        meta:
          type: "collection"
          models: [User]
        methods: ["get"]
        path: "/users"

      handler = util.createHandler route
      should.exist handler.get
      should.not.exist handler.post
      handler.get.length.should.equal 3
      done()

