async = require 'async'

# Util for executing query with hooks

module.exports = (model, req, res, query, cb) ->
  async.waterfall [
    (done) => @runPre 'query', [req, res, query], done
  ,
    (done) => model.runPre 'query', [req, res, query], done
  ,
    (done) => query.exec done
  ,
    (result, done) => model.runPost 'query', [req, res, query, result], (err) -> done err, result
  ,
    (result, done) => @runPost 'query', [req, res, query, result], (err) -> done err, result
  ], cb