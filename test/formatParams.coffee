{util} = crudify = require '../'
should = require 'should'
require 'mocha'

db = require './fixtures/connection'
User = db.model 'User'

describe 'formatParams()', ->
  describe 'flags', ->
    it 'should create flags object', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params = {}

      query = util.formatParams params, User
      should.exist query.flags
      done()

  describe 'skip', ->
    it 'should work with valid string number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        skip: "10"

      query = util.formatParams params, User
      should.exist query.skip
      query.skip.should.equal 10
      done()

    it 'should work with valid number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        skip: 10

      query = util.formatParams params, User
      should.exist query.skip
      query.skip.should.equal 10
      done()

    it 'should ignore invalid number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        skip: "blah"

      query = util.formatParams params, User
      should.not.exist query.skip
      done()

    it 'should ignore 0 number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        skip: 0

      query = util.formatParams params, User
      should.not.exist query.skip
      done()

  describe 'limit', ->
    it 'should work with valid string number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        limit: "10"

      query = util.formatParams params, User
      should.exist query.limit
      query.limit.should.equal 10
      done()

    it 'should work with valid number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        limit: 10

      query = util.formatParams params, User
      should.exist query.limit
      query.limit.should.equal 10
      done()

    it 'should ignore invalid number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        limit: "blah"

      query = util.formatParams params, User
      should.not.exist query.limit
      done()

    it 'should ignore 0 number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        limit: 0

      query = util.formatParams params, User
      should.not.exist query.limit
      done()

  describe 'sort', ->
    it 'should work with valid field name', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        sort: "score"

      query = util.formatParams params, User
      should.exist query.sort
      query.sort.should.eql ['score']
      done()

    it 'should work with valid field name and - operator', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        sort: "-score"

      query = util.formatParams params, User
      should.exist query.sort
      query.sort.should.eql ['-score']
      done()

    it 'should ignore invalid field name', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        sort: "blah"

      query = util.formatParams params, User
      query.sort.should.eql []
      done()

    it 'should ignore invalid field name with - operator', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        sort: "-blah"

      query = util.formatParams params, User
      query.sort.should.eql []
      done()

  describe 'populate', ->
    it 'should work with valid field name', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        populate: "bestFriend"

      query = util.formatParams params, User
      should.exist query.populate
      query.populate.should.eql ["bestFriend"]
      done()

    it 'should ignore invalid field name', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        populate: "blah"

      query = util.formatParams params, User
      query.populate.should.eql []
      done()

  describe 'where', ->
    it 'should work with valid field name', (done) ->
      query = User.find()
      params =
        name: "Tom"
        score: 100

      query = util.formatParams params, User
      should.exist query.conditions
      query.conditions.should.eql
        name: "Tom"
        score: 100
      done()

    it 'should ignore invalid field names from valid', (done) ->
      query = User.find()
      params =
        blah: "Tom"
        score: 100

      query = util.formatParams params, User
      should.exist query.conditions
      query.conditions.should.eql score: 100
      done()

    it 'should ignore invalid field names completely', (done) ->
      query = User.find()
      params =
        blah: "Tom"
        zzz: 100

      query = util.formatParams params, User
      should.exist query.conditions
      should.not.exist query.conditions.blah
      should.not.exist query.conditions.zzz
      done()