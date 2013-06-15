app = require "../../fixtures/app"
db = require "../../fixtures/connection"
User = db.model "User"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  describe 'GET /users/:id', ->

    it 'should return user with populate', (done) ->
      User.findOne().populate("bestFriend").exec (err, user) ->
        opt =
          method: "GET"
          json: true
          uri: app.url "/users/#{user._id}?populate=bestFriend"
          
        request opt, (err, res, body) ->
          should.not.exist err
          res.statusCode.should.equal 200
          should.exist body
          should.exist body.name
          body.name.should.equal user.name
          body.score.should.equal user.score
          body.bestFriend.name.should.equal user.bestFriend.name
          body.bestFriend.score.should.equal user.bestFriend.score
          done()
