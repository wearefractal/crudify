app = require "../../fixtures/app"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  describe 'GET /users', ->

    it 'should return all users with limit', (done) ->
      opt =
        method: "GET"
        json: true
        uri: app.url "/users?limit=1"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        Array.isArray(body).should.equal true
        body.length.should.equal 1
        done()
