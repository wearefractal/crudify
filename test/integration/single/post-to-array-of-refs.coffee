app = require "../../fixtures/app"
db = require "../../fixtures/connection"
Comment = db.model "Comment"
seedData = require "../../fixtures/seedData"
request = require "request"
should = require "should"

describe "crudify integration", ->
  describe 'POST /posts/:id/comments', ->

    it 'should add comment to the list', (done) ->

      post = seedData.embed "Post"

      opt =
        method: "POST"
        json:
          user: seedData.ref "User"
          body: "Test comment"
        uri: app.url "/posts/#{post._id}/comments"
        
      request opt, (err, res, body) ->
        should.not.exist err
        res.statusCode.should.equal 200
        should.exist body
        Array.isArray(body).should.equal true
        body.length.should.equal post.comments.length + 1
        done()

