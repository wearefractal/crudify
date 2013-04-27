JSONStream = require 'JSONStream'

module.exports = (res, format, stream) ->
  if format is 'json'
    res.status 200
    stream.pipe(JSONStream.stringify()).pipe(res)
    return 
  else # TODO: add xml support
    return res.send 200, error: "Not suppported yet"