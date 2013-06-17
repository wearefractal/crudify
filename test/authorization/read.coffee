crudify = require '../../'
should = require 'should'
express = require 'express'
request = require 'request'
require 'mocha'

{Schema} = require 'mongoose'
db = require '../fixtures/connection'

fakeReq = {}

rn = (max) -> Math.floor(Math.random()*max)

generateKey = (len=16) ->
  [num, alpb, alps] = ["0123456789", "ABCDEFGHIJKLMNOPQRSTUVWXTZ", "abcdefghiklmnopqrstuvwxyz"]
  [chars, key] = [(alpb + num + alps).split(''),""]
  key += chars[rn(chars.length)] for i in [1..len]
  return key

describe 'authorize read', ->

  it 'should pass with no authorize', (done) ->

    SpecialSchema = new Schema
      name: String

    Special = db.model generateKey(), SpecialSchema

    opt =
      args: [fakeReq]
      collection: Special

    crudify.util.authorizeRead opt, (isLegit) ->
      should.exist isLegit
      isLegit.should.equal true
      done()


  # collection
  it 'should pass when collection-level read is true', (done) ->

    SpecialSchema = new Schema
      name: String

    SpecialSchema.statics.authorize = (req, cb) ->
      should.exist @
      @.should.equal Special
      should.exist req
      should.exist cb
      req.should.equal fakeReq
      perms =
        read: true
        write: true
      cb perms

    Special = db.model generateKey(), SpecialSchema

    opt =
      args: [fakeReq]
      collection: Special

    crudify.util.authorizeRead opt, (isLegit) ->
      should.exist isLegit
      isLegit.should.equal true
      done()

  it 'should fail when collection-level read is false', (done) ->

    SpecialSchema = new Schema
      name: String

    SpecialSchema.statics.authorize = (req, cb) ->
      should.exist @
      @.should.equal Special
      should.exist req
      should.exist cb
      req.should.equal fakeReq
      perms =
        read: false
        write: true
      cb perms

    Special = db.model generateKey(), SpecialSchema

    opt =
      args: [fakeReq]
      collection: Special

    crudify.util.authorizeRead opt, (isLegit) ->
      should.exist isLegit
      isLegit.should.equal false
      done()

  # instance
  it 'should pass when instance-level read is true', (done) ->

    SpecialSchema = new Schema
      name: String

    SpecialSchema.statics.authorize = (req, cb) ->
      should.exist @
      @.should.equal Special
      should.exist req
      should.exist cb
      req.should.equal fakeReq
      perms =
        read: true
        write: true
      cb perms

    SpecialSchema.methods.authorize = (req, cb) ->
      should.exist @
      @.should.equal SpecialInstance
      should.exist req
      should.exist cb
      req.should.equal fakeReq
      perms =
        read: true
        write: true
      cb perms

    Special = db.model generateKey(), SpecialSchema
    SpecialInstance = new Special

    opt =
      args: [fakeReq]
      collection: Special
      model: SpecialInstance

    crudify.util.authorizeRead opt, (isLegit, docco) ->
      should.exist isLegit
      isLegit.should.equal true
      should.exist docco
      done()

  it 'should fail when instance-level read is false', (done) ->

    SpecialSchema = new Schema
      name: String

    SpecialSchema.statics.authorize = (req, cb) ->
      should.exist @
      @.should.equal Special
      should.exist req
      should.exist cb
      req.should.equal fakeReq
      perms =
        read: true
        write: true
      cb perms

    SpecialSchema.methods.authorize = (req, cb) ->
      should.exist @
      @.should.equal SpecialInstance
      should.exist req
      should.exist cb
      req.should.equal fakeReq
      perms =
        read: false
        write: true
      cb perms

    Special = db.model generateKey(), SpecialSchema
    SpecialInstance = new Special

    opt =
      args: [fakeReq]
      collection: Special
      model: SpecialInstance

    crudify.util.authorizeRead opt, (isLegit, docco) ->
      should.exist isLegit
      isLegit.should.equal false
      should.not.exist docco
      done()

  # multiple instances
  it 'should filter with multiple instances', (done) ->

    SpecialSchema = new Schema
      name: String

    SpecialSchema.methods.authorize = (req, cb) ->
      should.exist req
      should.exist cb
      req.should.equal fakeReq
      perms =
        read: (@name is 'Todd')
        write: true
      cb perms

    Special = db.model generateKey(), SpecialSchema
    SpecialInstance = new Special name: 'Todd'
    SpecialInstance2 = new Special

    opt =
      args: [fakeReq]
      collection: Special
      models: [SpecialInstance, SpecialInstance2]

    crudify.util.authorizeRead opt, (isLegit, docco) ->
      should.exist isLegit
      isLegit.should.equal true, 'isLegit'
      should.exist docco
      Array.isArray(docco).should.equal true, 'isArray'
      docco.length.should.equal 1
      String(docco[0]._id).should.equal String SpecialInstance._id
      done()

  # field-level instance
  it 'should filter by field and allow when true', (done) ->

    SpecialSchema = new Schema
      name:
        type: String
        authorize: (req, cb) ->
          should.exist req
          should.exist cb
          req.cookie.should.equal 'DGAF'
          perms =
            read: true
            write: true
          cb perms

    Special = db.model generateKey(), SpecialSchema
    SpecialInstance = new Special name: 'Todd'

    opt =
      args: [{cookie:'DGAF'}]
      collection: Special
      model: SpecialInstance

    crudify.util.authorizeRead opt, (isLegit, docco) ->
      should.exist isLegit
      isLegit.should.equal true, 'isLegit'
      should.exist docco
      String(docco._id).should.equal String SpecialInstance._id
      should.exist docco.name
      docco.name.should.equal SpecialInstance.name
      done()

  it 'should filter by field and remove when false', (done) ->

    SpecialSchema = new Schema
      name:
        type: String
        authorize: (req, cb) ->
          should.exist req
          should.exist cb
          req.cookie.should.equal 'DGAF'
          perms =
            read: false
            write: true
          cb perms

    Special = db.model generateKey(), SpecialSchema
    SpecialInstance = new Special name: 'Todd'

    opt =
      args: [{cookie:'DGAF'}]
      collection: Special
      model: SpecialInstance

    crudify.util.authorizeRead opt, (isLegit, docco) ->
      should.exist isLegit
      isLegit.should.equal true, 'isLegit'
      should.exist docco
      String(docco._id).should.equal String SpecialInstance._id
      should.not.exist docco.name
      done()

  # field-level for multiple
  it 'should filter by field and allow when true for multiple models', (done) ->
    SpecialSchema = new Schema
      name:
        type: String
        authorize: (req, cb) ->
          should.exist req
          should.exist cb
          req.cookie.should.equal 'DGAF'
          perms =
            read: true
            write: true
          cb perms

    Special = db.model generateKey(), SpecialSchema
    SpecialInstance = new Special name: 'Todd'
    SpecialInstance2 = new Special name: 'Rob'

    opt =
      args: [{cookie:'DGAF'}]
      collection: Special
      models: [SpecialInstance, SpecialInstance2]

    crudify.util.authorizeRead opt, (isLegit, docco) ->
      should.exist isLegit
      isLegit.should.equal true, 'isLegit'
      should.exist docco
      String(docco[0]._id).should.equal String SpecialInstance._id
      String(docco[1]._id).should.equal String SpecialInstance2._id
      should.exist docco[0].name
      should.exist docco[1].name
      docco[0].name.should.equal SpecialInstance.name
      docco[1].name.should.equal SpecialInstance2.name
      done()

  it 'should filter by field and remove when false for multiple models', (done) ->
    SpecialSchema = new Schema
      name:
        type: String
        authorize: (req, cb) ->
          should.exist req
          should.exist cb
          req.cookie.should.equal 'DGAF'
          perms =
            read: false
            write: true
          cb perms

    Special = db.model generateKey(), SpecialSchema
    SpecialInstance = new Special name: 'Todd'
    SpecialInstance2 = new Special

    opt =
      args: [{cookie:'DGAF'}]
      collection: Special
      models: [SpecialInstance, SpecialInstance2]

    crudify.util.authorizeRead opt, (isLegit, docco) ->
      should.exist isLegit
      isLegit.should.equal true, 'isLegit'
      should.exist docco
      String(docco[0]._id).should.equal String SpecialInstance._id
      String(docco[1]._id).should.equal String SpecialInstance2._id
      should.not.exist docco[0].name
      should.not.exist docco[1].name
      done()

