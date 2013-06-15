app = require "../../fixtures/app"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  describe 'GET /users', ->

    it 'should return all users with sort ascending', (done) ->
      opt =
        method: "GET"
        json: true
        uri: app.url "/users?sort=-score"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        Array.isArray(body).should.equal true
        body.length.should.equal 30
        (body[0].score >= body[1].score).should.equal true
        done()
