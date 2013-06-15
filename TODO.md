## TODO for 0.1

- Benchmarks/memory leak testing
- Convert as much logic as possible into middleware pieces
- Set the default skip/limit to 0/20 for all collection views [ccowan]
- Have a way to override the collection query (Model.find()) to use a static method from the model [ccowan]
- Specify query restrictions like max limit, max specificity, etc.
- Allow people to specify which fields are selected via querystring
- Allow autopopulate of fields to be defined on model
- friendly event names and middleware hooks (user created, user modified, user removed, etc.)
- Look for dead code paths using test coverage stuff
- Properly respond to OPTIONS with endpoint meta info (schema, accepted content-types, etc. see https://github.com/wearefractal/crudify/issues/3)
- Strip _v (or versionKey as specified in db config) from incoming bodies and outgoing responses (let use config this - impl as middleware)
- Support TRACE requests
- Figure out a cleaner way to attach authorize to instance/collection
- PUT single-with-populate-many should add an existing record, POST should create and add
- DELETE to remove items from single-with-populate-many (/users/:id/friends)
- Prevent mongoose from caching populates
- Create a more modular way to configure at the field level