## TODO for 0.1

- Support populate via path (also includes recursive routes)
- Filter all models by authorization on collection methods
- Add middleware hook for http response that allows transforms
- More tests
- Set the default skip/limit to 0/20 for all collection views [ccowan]
- Have a way to overide the collection query (Model.find()) to use a static method from the model [ccowan]
- Specify query restrictions like max limit, max specificity, etc.
- Allow people to specify which fields are selected via querystring
- Attach meta info to http request object before passing it to authorize or handlers
- Allow autopopulate on model
