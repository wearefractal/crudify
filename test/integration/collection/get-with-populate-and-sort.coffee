app = require "../../fixtures/app"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  describe 'GET /users', ->

    it.skip 'should return all users with sort and populate', (done) ->
      opt =
        method: "GET"
        json: true
        uri: app.url "/users?populate=bestFriend&sort=-bestFriend.score"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        Array.isArray(body).should.equal true
        body.length.should.equal 30
        (body[0].bestFriend.score >= body[29].bestFriend.score).should.equal true
        done()
