app = require "../../fixtures/app"
seedData = require "../../fixtures/seedData"
db = require "../../fixtures/connection"
User = db.model "User"
request = require "request"
should = require "should"

describe "crudify integration", ->

  beforeEach (done) -> app.start -> seedData.create done
  afterEach (done) -> app.close -> seedData.clear done

  describe 'GET /users', ->

    it 'should return all users by bestFriend', (done) ->
      user = seedData.embed "User"
      User.find().where("bestFriend").equals(user.bestFriend).exec (err, docs)->
        opt =
          method: "GET"
          json: true
          uri: app.url "/users?bestFriend=#{user.bestFriend}"
          
        request opt, (err, res, body) ->
          should.not.exist err
          res.statusCode.should.equal 200
          should.exist body
          Array.isArray(body).should.equal true
          body.length.should.equal docs.length
          body[0].name.should.equal docs[0].name
          done()
