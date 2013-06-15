app = require "../../fixtures/app"
db = require "../../fixtures/connection"
User = db.model "User"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  beforeEach (done) -> app.start -> seedData.create done
  afterEach (done) -> app.close -> seedData.clear done

  describe 'DELETE /users/:id', ->

    it 'should update user', (done) ->
      user = seedData.embed "User"
      opt =
        method: "DELETE"
        json: true
        uri: app.url "/users/#{user._id}"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        should.exist body.name
        body.name.should.equal user.name
        body.score.should.equal user.score
        done()

