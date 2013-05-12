module.exports = (res, err, code=500) ->
  res.set 'Content-Type', 'application/json'
  if typeof err is 'string'
    res.send code,
      error:
        message: err
  else
    res.send code, error: err

  return res