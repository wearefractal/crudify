app = require "../../fixtures/app"
db = require "../../fixtures/connection"
User = db.model "User"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->
  describe 'GET /users/:id/friends', ->

    it 'should return populated friends list', (done) ->
      user = seedData.embed "User"
      User.populate user, "friends", (err, user) ->
        opt =
          method: "GET"
          json: true
          uri: app.url "/users/#{user._id}/friends"
          
        request opt, (err, res, body) ->
          should.not.exist err
          res.statusCode.should.equal 200
          should.exist body
          Array.isArray(body).should.equal true
          body.length.should.equal user.friends.length
          friendIds = (friend._id for friend in body)
          friendIds.should.include String user.friends[0]._id
          done()

