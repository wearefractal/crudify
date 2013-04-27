sendError = require './sendError'
sendResult = require './sendResult'
sendResultStream = require './sendResultStream'

module.exports = (query, res) ->
  if query.flags.stream
    stream = query.stream()
    sendResultStream res, stream
    return

  query.exec (err, data) ->
    return sendError res, err if err?
    sendResult res, data
    return

  return query
