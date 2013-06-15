app = require "../../fixtures/app"
db = require "../../fixtures/connection"
Comment = db.model "Comment"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->
  describe 'GET /users/:id/findWithSameName', ->

    it 'should return user', (done) ->
      user = seedData.embed "User"
      opt =
        method: "GET"
        json: true
        uri: app.url "/users/#{user._id}/findWithSameName?q=#{user.name}"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        should.exist body.name
        should.exist body.query
        body.name.should.equal user.name
        body.query.should.equal user.name
        done()
