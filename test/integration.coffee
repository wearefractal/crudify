crudify = require '../'
should = require 'should'
express = require 'express'
request = require 'request'
require 'mocha'

db = require './fixtures/connection'
User = db.model 'User'
crud = crudify db
crud.expose 'User'

PORT = process.env.PORT or 9001

app = express()
crud.hook app
app.listen PORT

tom =
  name: "Tom Johnson"
  score: 100

mike =
  name: "Mike Johnson"
  score: 50

TomModel = null
MikeModel = null

beforeEach (done) ->
  User.create tom, (err, doc) ->
    return done err if err?
    TomModel = doc
    User.create mike, (err, doc) ->
      return done err if err?
      MikeModel = doc
      done()

afterEach db.wipe

describe 'crudify integration', ->

  describe 'GET /users', ->
    it 'should return all users', (done) ->
      opt =
        method: "GET"
        uri: "http://localhost:#{PORT}/users"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        body = JSON.parse body
        Array.isArray(body).should.equal true
        body.length.should.equal 2
        done()

    it 'should return all users with limit', (done) ->
      opt =
        method: "GET"
        uri: "http://localhost:#{PORT}/users?limit=1"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        body = JSON.parse body
        Array.isArray(body).should.equal true
        body.length.should.equal 1
        done()

    it 'should return all users with skip', (done) ->
      opt =
        method: "GET"
        uri: "http://localhost:#{PORT}/users?skip=1"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        body = JSON.parse body
        Array.isArray(body).should.equal true
        body.length.should.equal 1
        done()

    it 'should return all users with sort descending', (done) ->
      opt =
        method: "GET"
        uri: "http://localhost:#{PORT}/users?sort=score"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        body = JSON.parse body
        Array.isArray(body).should.equal true
        body.length.should.equal 2
        (body[0].score <= body[1].score).should.equal true
        done()

    it 'should return all users with sort ascending', (done) ->
      opt =
        method: "GET"
        uri: "http://localhost:#{PORT}/users?sort=-score"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        body = JSON.parse body
        Array.isArray(body).should.equal true
        body.length.should.equal 2
        (body[0].score >= body[1].score).should.equal true
        done()