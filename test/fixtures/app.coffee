crudify = require '../../'
should = require 'should'
http = require 'http'
express = require 'express'
request = require 'request'
seedData = require "./seedData"
require 'mocha'

db = require './connection'
User = db.model 'User'
Post = db.model 'Post'
Comment = db.model 'Comment'
crud = module.exports.crud = crudify db
userMod = module.exports.userMod = crud.expose 'User'
postMod = module.exports.postMod  = crud.expose 'Post'
commentMod = module.exports.commentMod = crud.expose 'Comment'
app = express()
app.use express.bodyParser()

crud.pre 'handle', (req, res, next) ->
  should.exist req
  should.exist res
  next()

userMod.pre 'handle', (req, res, next) ->
  should.exist req
  should.exist res
  next()

userMod.pre 'query', (req, res, query, next) ->
  should.exist req
  should.exist res
  next()

userMod.post 'query', (req, res, query, result, next) ->
  should.exist req
  should.exist res
  should.exist result
  next()

crud.hook app

server = http.createServer(app)

PORT = process.env.PORT or 9001

module.exports.url = (url) -> "http://localhost:#{PORT}#{url}"

beforeEach (done) ->
  server.listen PORT, -> seedData.create done

afterEach (done) ->
  server.close -> db.wipe done


