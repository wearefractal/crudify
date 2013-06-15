app = require "../../fixtures/app"
db = require "../../fixtures/connection"
User = db.model "User"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->
  describe 'GET /users/:id/friends', ->

    it 'should return populated friends list', (done) ->
      User.findOne().populate('friends').exec (err, user) ->
        opt =
          method: "GET"
          json: true
          uri: app.url "/users/#{user._id}/friends"
          
        request opt, (err, res, body) ->
          should.not.exist err
          res.statusCode.should.equal 200
          should.exist body
          Array.isArray(body).should.equal true
          console.log 'Body'
          console.log (u._id for u in body)
          console.log 'User', user._id
          console.log (z._id for z in user.friends), user.bestFriend
          console.log ''
          body.length.should.equal user.friends.length
          friendIds = (friend._id for friend in body)
          friendIds.should.include String user.friends[0]._id
          done()

