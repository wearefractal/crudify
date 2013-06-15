app = require "../../fixtures/app"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->
  describe 'GET /users/search', ->

    it 'should call the static method', (done) ->
      opt =
        method: "GET"
        json: true
        uri: app.url "/users/search?q=test"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        should.exist body.query
        body.query.should.eql 'test'
        done()
