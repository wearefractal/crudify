module.exports = (res, err) ->
  msg = err.message or err
  res.set 'Content-Type', 'application/json'
  return res.send 500, error: msg