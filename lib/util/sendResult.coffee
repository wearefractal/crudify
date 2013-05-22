async = require 'async'

module.exports = (model, req, res, data, code=200) ->
  async.waterfall [
    (done) => @runPre 'send', [req, res, data, code], done
  ,
    (done) => model.runPre 'send', [req, res, data, code], done
  ,
    (done) =>
      res.set 'Content-Type', 'application/json'
      res.send code, data
      done()
  ,
    (done) => model.runPost 'send', [req, res, data, code], done
  ,
    (done) => @runPost 'send', [req, res, data, code], done
  ]

  return res