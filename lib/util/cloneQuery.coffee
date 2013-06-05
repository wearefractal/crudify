module.exports = (origQuery) ->
  query = origQuery.model.find origQuery._conditions
  query.op = origQuery.op
  query.flags = origQuery.flags or {}

  return query