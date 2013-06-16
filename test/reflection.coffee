crudify = require '../'
should = require 'should'
express = require 'express'
request = require 'request'
require 'mocha'

db = require './fixtures/connection'
User = db.model 'User'
crud = crudify db
userMod = crud.expose 'User'

PORT = process.env.PORT or 9002

app = express()
app.use express.bodyParser()

crud.hook app
app.listen PORT

describe 'crudify reflection/meta info', ->

  # collection
  describe 'GET /', ->
    it 'should return meta information', (done) ->
      opt =
        method: "GET"
        json: true
        uri: "http://localhost:#{PORT}/"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        should.exist body.collections
        should.exist body.collections[0]
        body.collections[0].name.should.equal 'users'
        should.exist body.collections[0].routes
        for route in body.collections[0].routes
          should.exist route.url
          should.exist route.type
          should.exist route.methods
        done()

  ###
  describe 'OPTIONS /users', ->
    it 'should return meta information', (done) ->
      opt =
        method: "OPTIONS"
        json: true
        uri: "http://localhost:#{PORT}/users"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        should.exist body.name
        body.name.should.equal 'users'
        should.exist body.routes
        for route in body.routes
          should.exist route.url
          should.exist route.type
          should.exist route.methods

        should.exist body.schema
        done()
  ###
  
