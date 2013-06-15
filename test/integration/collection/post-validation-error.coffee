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
        body.error.should.eql
          message: 'Validation failed'
          name: 'ValidationError'
          errors:
            name:
              message: 'Validator "required" failed for path name with value ``'
              name: 'ValidatorError'
              path: 'name'
              type: 'required'
              value: ''
        done()
