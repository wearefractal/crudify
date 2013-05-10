hasField = require './hasField'

reserved = ["skip","limit","sort","populate"]

validArg = (v) -> v?
validNumber = (v) -> validArg(v) and !isNaN v
validField = (v) -> validArg(v) and v.length > 0
isTrue = (v) -> (v is true) or (v is 'true')
getField = (v) ->
  return v[1...] if (v[0] is '-')
  return v

###
skip can be a number or string of a number greater than 0
limit can be a number or string of a number greater than 0
sort can be a field name optionally prefixed with + or - to set sort order
populate can be a field name
###

module.exports = (query, params={}) ->
  query.flags ?= {}

  # check for our standard params

  if validNumber params.skip
    skip = parseInt params.skip
    query.skip skip if skip > 0 # dont bother with jokers

  if validNumber params.limit
    limit = parseInt params.limit
    query.limit limit if limit > 0 # dont bother with jokers

  if validField params.sort
    actualField = getField params.sort
    if hasField query.model, actualField
      query.sort params.sort

  if validField params.populate
    actualField = getField params.populate
    if hasField query.model, actualField
      query.populate params.populate

  # .where() all unreserved query params that are also model fields
  # longest line ever lol
  query.where name, val for name, val of params when !(name in reserved) and validField(name) and validArg(val) and hasField(query.model, name)
  return query