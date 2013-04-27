sendError = require './sendError'
sendResult = require './sendResult'
sendResultStream = require './sendResultStream'

module.exports = (query, res, cb) ->
  if query.flags.stream
    stream = query.stream()
    sendResultStream res, query.flags.format, stream
    cb()
    return

  query.exec (err, data) ->
    if err?
      sendError res, err
      cb err
      return
    sendResult res, query.flags.format, data
    cb()

  return query
