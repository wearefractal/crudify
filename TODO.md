## Todo Items for first

* Figure out single-with-populate shit
* Allow recursive routes
* Support nested populate querystring params
* Clean up code to be simpler
* Filter all models by authorization on collection methods
* Add model filter on single put/patch/post
* Fix getDefault on schemas
* Set the default skip/limit to 0/20 for all collection views [ccowan]
* Have a way to overide the collection query (Model.find()) to use a static method from the model [ccowan]
*  There should be a post query middleware for transforming the results before they are returned to the client. This would be used for transforming results for older api interfaces. [ccowan]
```coffee
 Model.transformer "collection", (docs, next) ->
   docs.map (doc) ->
     doc.first_name = doc.name.first
     doc.last_name = doc.name.last
     doc.nickname = doc.name.nick
     delete doc.name
```
