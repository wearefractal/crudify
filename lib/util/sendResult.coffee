module.exports = (res, data) ->
  res.set 'Content-Type', 'application/json'
  return res.send 200, data