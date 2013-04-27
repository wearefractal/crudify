crudify = require '../'
should = require 'should'
require 'mocha'

db = require './fixtures/connection'
User = db.model 'User'

describe 'crudify', ->
  describe 'exposed', ->
    it 'should expose stuff for extending and testing', (done) ->
      should.exist crudify.CRUD
      should.exist crudify.Model
      should.exist crudify.util
      done()
      
  describe 'crudify()', ->
    it 'should error without a db argument', (done) ->
      try
        crud = crudify()
      catch e
        should.exist e
        return done()

      throw new Error "Did not throw error"
      done()

    it 'should produce a CRUD instance when passed a db', (done) ->
      crud = crudify db
      should.exist crud
      should.exist crud.expose
      done()

  describe 'expose()', ->
    it 'should create a resource', (done) ->
      crud = crudify db
      resource = crud.expose 'User'
      should.exist resource
      done()

  describe 'get()', ->
    it 'should get a resource after expose', (done) ->
      crud = crudify db
      crud.expose 'User'
      resource = crud.get 'User'
      should.exist resource
      done()

  describe 'unexpose()', ->
    it 'should delete a resource', (done) ->
      crud = crudify db
      crud.expose 'User'
      crud.unexpose 'User'
      resource = crud.get 'User'
      should.not.exist resource
      done()