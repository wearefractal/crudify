## TODO for 0.1

- Think about doing recursive routes for relationships
- Convert as much logic as possible into middleware pieces
- More tests
- Set the default skip/limit to 0/20 for all collection views [ccowan]
- Have a way to overide the collection query (Model.find()) to use a static method from the model [ccowan]
- Specify query restrictions like max limit, max specificity, etc.
- Allow people to specify which fields are selected via querystring
- Allow autopopulate on model
- friendly event names and middleware hooks (user created, user modified, user removed, etc.)
- delete to remove items from a nested array of relationships (/users/:id/friends)
- more tests for querystring options to populated relationships
- test to check ignore certain querystring params depending on the situation (select, limit, where, etc.)
- Properly respond to OPTIONS with endpoint meta info (schema, accepted content-types, etc. see https://github.com/wearefractal/crudify/issues/3)
- Strip _v (or versionKey as specified in db config) from incoming bodies and outgoing responses
- Support TRACE requests
- Figure out a cleaner way to attach authorize to instance/collection
- PUT single-with-populate many should add an existing record, POST should create and add