module.exports = (res, data, code=200) ->
  res.set 'Content-Type', 'application/json'
  return res.send code, data