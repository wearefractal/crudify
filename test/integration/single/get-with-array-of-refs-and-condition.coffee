app = require "../../fixtures/app"
db = require "../../fixtures/connection"
User = db.model "User"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->
  describe 'GET /users/:id/friends', ->

    it 'should return populated friends list with where condition that validates', (done) ->
      User.findOne().populate('friends').exec (err, user) ->
        random = Math.floor(Math.random()*user.friends.length)
        friend = user.friends[random]

        opt =
          method: "GET"
          json: true
          uri: app.url "/users/#{user._id}/friends?name=#{friend.name}"
          
        request opt, (err, res, body) ->
          should.not.exist err
          res.statusCode.should.equal 200
          should.exist body
          Array.isArray(body).should.equal true
          body.length.should.equal 1
          body[0].name.should.equal friend.name
          done()

    it 'should return populated friends list with where condition', (done) ->
      User.findOne().populate('friends').exec (err, user) ->
        random = Math.floor(Math.random()*user.friends.length)
        friend = user.friends[random]

        opt =
          method: "GET"
          json: true
          uri: app.url "/users/#{user._id}/friends?name=Wrong"
          
        request opt, (err, res, body) ->
          should.not.exist err
          res.statusCode.should.equal 200
          should.exist body
          Array.isArray(body).should.equal true
          body.length.should.equal 0
          done()
    
