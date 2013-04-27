{util} = crudify = require '../'
should = require 'should'
require 'mocha'

db = require './fixtures/connection'
User = db.model 'User'

describe 'extendQueryFromParams()', ->
  describe 'flags', ->
    it 'should create flags object', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params = {}

      query = util.extendQueryFromParams query, params
      should.exist query.flags
      done()

    it 'should not override flags when extended twice', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        stream: true

      query = util.extendQueryFromParams query, params
      should.exist query.flags
      should.exist query.flags.stream
      query.flags.stream.should.equal true

      params2 =
        stream: true

      query = util.extendQueryFromParams query, params2
      should.exist query.flags
      should.exist query.flags.stream
      query.flags.stream.should.equal true
      should.exist query.flags.stream
      query.flags.stream.should.equal true
      done()

  describe 'skip', ->
    it 'should work with valid string number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        skip: "10"

      query = util.extendQueryFromParams query, params
      should.exist query.options.skip
      query.options.skip.should.equal 10
      done()

    it 'should work with valid number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        skip: 10

      query = util.extendQueryFromParams query, params
      should.exist query.options.skip
      query.options.skip.should.equal 10
      done()

    it 'should ignore invalid number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        skip: "blah"

      query = util.extendQueryFromParams query, params
      should.not.exist query.options.skip
      done()

    it 'should ignore 0 number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        skip: 0

      query = util.extendQueryFromParams query, params
      should.not.exist query.options.skip
      done()

  describe 'limit', ->
    it 'should work with valid string number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        limit: "10"

      query = util.extendQueryFromParams query, params
      should.exist query.options.limit
      query.options.limit.should.equal 10
      done()

    it 'should work with valid number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        limit: 10

      query = util.extendQueryFromParams query, params
      should.exist query.options.limit
      query.options.limit.should.equal 10
      done()

    it 'should ignore invalid number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        limit: "blah"

      query = util.extendQueryFromParams query, params
      should.not.exist query.options.limit
      done()

    it 'should ignore 0 number', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        limit: 0

      query = util.extendQueryFromParams query, params
      should.not.exist query.options.limit
      done()

  describe 'sort', ->
    it 'should work with valid field name', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        sort: "score"

      query = util.extendQueryFromParams query, params
      should.exist query.options.sort
      query.options.sort.should.eql [['score',1]]
      done()

    it 'should work with valid field name and - operator', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        sort: "-score"

      query = util.extendQueryFromParams query, params
      should.exist query.options.sort
      query.options.sort.should.eql [['score',-1]]
      done()

    it 'should ignore invalid field name', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        sort: "blah"

      query = util.extendQueryFromParams query, params
      should.not.exist query.options.sort
      done()

    it 'should ignore invalid field name with - operator', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        sort: "-blah"

      query = util.extendQueryFromParams query, params
      should.not.exist query.options.sort
      done()

  describe 'populate', ->
    it 'should work with valid field name', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        populate: "bestFriend"

      query = util.extendQueryFromParams query, params
      should.exist query.options.populate
      should.exist query.options.populate.bestFriend
      done()

    it 'should ignore invalid field name', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        populate: "blah"

      query = util.extendQueryFromParams query, params
      should.not.exist query.options.populate
      done()

  describe 'where', ->
    it 'should work with valid field name', (done) ->
      query = User.find()
      params =
        name: "Tom"
        score: 100

      query = util.extendQueryFromParams query, params
      should.exist query._conditions
      query._conditions.should.eql
        name: "Tom"
        score:100
      done()

    it 'should ignore invalid field names from valid', (done) ->
      query = User.find()
      params =
        blah: "Tom"
        score: 100

      query = util.extendQueryFromParams query, params
      should.exist query._conditions
      query._conditions.should.eql score: 100
      done()

    it 'should ignore invalid field names completely', (done) ->
      query = User.find()
      params =
        blah: "Tom"
        zzz: 100

      query = util.extendQueryFromParams query, params
      should.exist query._conditions
      should.not.exist query._conditions.blah
      should.not.exist query._conditions.zzz
      done()

  describe 'misc', ->
    it 'should work with all', (done) ->
      query = User.find()
      query.where('name').in(["Tom","Rob"])
      params =
        bestFriend: "someId"
        invalidShit: "nothing"
        offset: "3"
        limit: "10"
        sort: "score"

      util.extendQueryFromParams query, params
      done()