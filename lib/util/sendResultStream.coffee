JSONStream = require 'JSONStream'

module.exports = (res, stream) ->
  res.status 200
  stream.pipe(JSONStream.stringify()).pipe(res)
  return 