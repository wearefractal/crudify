async = require 'async'

# Util for executing query with hooks

module.exports = (req, res, query, cb) ->
  async.waterfall [
    (done) => @runPre 'query', [req, res, query], done
  ,
    (done) => query.exec done
  ,
    (mod, done) => @runPost 'query', [req, res, query, mod], (err) -> done err, mod
  ], cb