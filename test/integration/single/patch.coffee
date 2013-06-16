app = require "../../fixtures/app"
db = require "../../fixtures/connection"
User = db.model "User"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  describe 'PATCH /users/:id', ->

    it 'should update user', (done) ->
      User.findOne().exec (err, user) ->
        opt =
          method: "PATCH"
          uri: app.url "/users/#{user._id}"
          json:
            score: 9001
          
        request opt, (err, res, body) ->
          should.not.exist err
          res.statusCode.should.equal 200
          should.exist body
          should.exist body.name
          body.name.should.equal user.name
          body.score.should.equal 9001
          done()
