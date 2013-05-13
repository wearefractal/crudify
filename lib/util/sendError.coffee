module.exports = (res, err) ->
  res.set 'Content-Type', 'application/json'
  return res.send 500, error: err