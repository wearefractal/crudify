app = require "../../fixtures/app"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  describe 'GET /users', ->

    it 'should return all users with populate of two fields', (done) ->
      opt =
        method: "GET"
        json: true
        uri: app.url "/users?populate=bestFriend&populate=friends"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        Array.isArray(body).should.equal true
        body.length.should.equal 30
        should.exist body[0].bestFriend
        should.exist body[0].bestFriend.score
        should.exist body[1].bestFriend
        should.exist body[1].bestFriend.score
        should.exist body[0].friends[0]
        should.exist body[0].friends[0].score
        should.exist body[1].friends[0]
        should.exist body[1].friends[0].score
        done()
