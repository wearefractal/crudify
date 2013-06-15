app = require "../../fixtures/app"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  beforeEach (done) -> app.start -> seedData.create done
  afterEach (done) -> app.close -> seedData.clear done

  describe 'GET /users', ->
    it 'should error with no read', (done) ->
      opt =
        method: "GET"
        json: true
        uri: app.url "/users"
        headers:
          hasRead: "false"
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 401
        should.exist body
        should.exist body.error
        should.exist body.error.message
        body.error.message.should.equal "Not authorized"
        done()


