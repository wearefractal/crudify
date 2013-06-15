app = require "../../fixtures/app"
db = require "../../fixtures/connection"
User = db.model "User"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->
  describe 'GET /users/:id/bestFriend', ->

    beforeEach (done) -> app.start -> seedData.create done
    afterEach (done) -> app.close -> seedData.clear done

    it 'should return populated friend', (done) ->
      user = seedData.embed "User"
      User.populate user, "bestFriend", (err, user) ->
        opt =
          method: "GET"
          json: true
          uri: app.url "/users/#{user._id}/bestFriend"
          
        request opt, (err, res, body) ->
          should.not.exist err
          res.statusCode.should.equal 200
          should.exist body
          should.exist body.name
          body.name.should.equal user.bestFriend.name
          body.score.should.equal user.bestFriend.score
          done()
