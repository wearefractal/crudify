app = require "../../fixtures/app"
db = require "../../fixtures/connection"
User = db.model "User"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  beforeEach (done) -> app.start -> seedData.create done
  afterEach (done) -> app.close -> seedData.clear done

  describe 'PUT /users/:id', ->

    it 'should error on field change with no write', (done) ->
      user = seedData.embed "User"
      opt =
        method: "PUT"
        uri: app.url "/users/#{user._id}"
        json:
          name: "Rob"
          password: "jah"

      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 401
        should.exist body
        should.exist body.error
        should.exist body.error.message
        body.error.message.should.equal "Not authorized"
        done()
