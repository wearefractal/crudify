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

      TomModel.set 'bestFriend', MikeModel
      MikeModel.set 'bestFriend', TomModel

      TomModel.save (err) ->
        return done err if err?
        MikeModel.save (err) ->
          return done err if err?
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

    it 'should return all users with populate', (done) ->
      opt =
        method: "GET"
        uri: "http://localhost:#{PORT}/users?populate=bestFriend"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        body = JSON.parse body
        Array.isArray(body).should.equal true
        body.length.should.equal 2
        should.exist body[0].bestFriend
        should.exist body[0].bestFriend.score
        should.exist body[1].bestFriend
        should.exist body[1].bestFriend.score
        done()

  describe 'GET /users/:id', ->
    it 'should return user', (done) ->
      opt =
        method: "GET"
        uri: "http://localhost:#{PORT}/users/#{TomModel._id}"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        body = JSON.parse body
        should.exist body.name
        body.name.should.equal TomModel.name
        body.score.should.equal TomModel.score
        body.bestFriend.should.equal String MikeModel._id
        done()

    it 'should return user with populate', (done) ->
      opt =
        method: "GET"
        uri: "http://localhost:#{PORT}/users/#{TomModel._id}?populate=bestFriend"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        body = JSON.parse body
        should.exist body.name
        body.name.should.equal TomModel.name
        body.score.should.equal TomModel.score
        body.bestFriend.name.should.equal MikeModel.name
        body.bestFriend.score.should.equal MikeModel.score
        done()

    it 'should return users with populated friend', (done) ->
      opt =
        method: "GET"
        uri: "http://localhost:#{PORT}/users/#{TomModel._id}/bestFriend"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        body = JSON.parse body
        should.exist body.name
        body.name.should.equal MikeModel.name
        body.score.should.equal MikeModel.score
        done()