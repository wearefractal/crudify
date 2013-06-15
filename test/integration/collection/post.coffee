app = require "../../fixtures/app"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  describe 'POST /users', ->

    it 'should create a user', (done) ->
      opt =
        method: "POST"
        json:
          name: "New Guy"
        uri: app.url "/users"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 201
        should.exist body
        body.name.should.equal "New Guy"
        body.score.should.equal 0
        done()

