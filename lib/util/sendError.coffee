module.exports = (res, err) ->
  msg = err.message or err
  return res.send 500, error: msg