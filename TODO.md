## TODO for 0.1

- Finish integrating hookify
- Figure out if we need to support populate via path (also includes recursive routes)
- Pass full http request into static/instance handlers
- Filter all models by authorization on collection methods
- Add model filter on single put/patch/post
- Correct response codes for each operation
- Fix getDefault on schemas to support functions
- Set the default skip/limit to 0/20 for all collection views [ccowan]
- Have a way to overide the collection query (Model.find()) to use a static method from the model [ccowan]
- There should be a post query middleware for transforming the results before they are returned to the client. This would be used for transforming results for older api interfaces. [ccowan]

```coffee
crud = crudify db
model = crud.expose "User"
# Not sure if this will need to be async or not.
model.transform (doc) ->
   doc.first_name = doc.name.first
   doc.last_name = doc.name.last
   doc.nickname = doc.name.nick
   delete doc.name
crud.hook "/api/v2", app
```

- Specify query restrictions like max limit, max specificity, etc.
- Allow people to specify which fields are selected via querystring
- Attach meta info to http request object before passing it to authorize or handlers
