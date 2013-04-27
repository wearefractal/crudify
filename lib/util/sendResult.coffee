module.exports = (res, format, data) ->
  if format is 'json'
    res.set 'Content-Type', 'application/json'
    return res.send 200, data
  else # TODO: add xml support
    return res.send 200, error: "Not suppported yet"