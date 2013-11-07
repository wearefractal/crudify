app = require "../../fixtures/app"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->

  describe 'POST /users', ->
    
    it 'have a validation error if name is blank', (done) ->
      opt =
        method: "POST"
        json:
          name: ""
        uri: app.url "/users"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 500
        should.exist body
        should.exists body.error.errors.name
        body.error.errors.name.type.should.equal 'required'
        done()
