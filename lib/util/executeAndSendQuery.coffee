sendError = require './sendError'
sendResult = require './sendResult'
sendResultStream = require './sendResultStream'

module.exports = (query, res) ->
  if query.flags.stream
    stream = query.stream()
    sendResultStream res, query.flags.format, stream
    return

  query.exec (err, data) ->
    return sendError res, err if err?z
    sendResult res, query.flags.format, data
    return

  return query
