app = require "../../fixtures/app"
db = require "../../fixtures/connection"
User = db.model "User"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  describe 'PUT /users/:id', ->

    it 'should not update reset field with no write', (done) ->
      user = seedData.embed "User"
      opt =
        method: "PUT"
        uri: app.url "/users/#{user._id}"
        json:
          name: "Rob"

      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        should.exist body.name
        body.name.should.equal "Rob"
        body.score.should.equal 0
        body.password.should.equal "pass123"
        done()
