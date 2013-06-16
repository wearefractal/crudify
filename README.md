![status](https://secure.travis-ci.org/wearefractal/crudify.png?branch=master)

## Information

<table>
<tr> 
<td>Package</td><td>crudify</td>
</tr>
<tr>
<td>Description</td>
<td>Mongoose CRUD generator</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.6</td>
</tr>
</table>

## Usage

```coffee-script
db = mongoose.createConnection()
app = express()

# Set up DB
UserModel = new Schema
  name:
    type: String
    required: true

  bestFriend:
    type: Schema.Types.ObjectId
    ref: 'User'

  friends: [
    type: Schema.Types.ObjectId
    ref: 'User'
  ]

db.model 'User', UserModel

# Set up crudify
crud = crudify db
crud.expose 'User'

# Plug it into express
crud.hook app

app.listen 8080
```

## Authorization

crudify allows you to specify authorization on pretty much everything. Here are some details on the way it works.

Let's take this model for example

```coffee-script
{Schema} = mongoose = require 'mongoose'

UserModel = new Schema

  name:
    type: String
    required: true

  password:
    type: String
    authorize: (req) ->
      permission =
        read: false
        write: false
      return permission

  score:
    type: Number
    default: 0
    
  bestFriend:
    type: Schema.Types.ObjectId
    ref: 'User'

  friends: [
    type: Schema.Types.ObjectId
    ref: 'User'
  ]

UserModel.statics.search = (opt, cb) -> cb null, {query: opt.q}
UserModel.methods.findWithSameName = (opt, cb) ->  cb null, {name: @name, query: opt.q}

UserModel.statics.authorize = (req) ->
  permission =
    read: true
    write: true
  return permission

UserModel.methods.authorize = (req) ->
  permission =
    read: true
    write: false
    delete: false
  return permission

module.exports = UserModel
```

### Collection

GET /users

Will run UserModel.statics.authorize. If read is false, it will return an error. The query is executed and UserModel.methods.authorize is run on each model returned from the database. If read is false, it will remove the model from the results. For any fields with an authorize function specified, it will be run on each model. If read is false the field will be removed from the model in the results. The results are now returned.

POST /users

Will run UserModel.statics.authorize. If read is false, it will return an error. If write is false, it will return an error. The document is saved to the database and returned to the caller.

GET/POST /users/search

Will run UserModel.statics.authorize. If read is false, it will return an error. The querystring/body (depending on if it is a GET or POST) is passed to UserModel.statics.search which is responsible for returning a response and any further authorization.

### Single

GET /users/:id

Will run UserModel.statics.authorize. If read is false, it will return an error. The query is executed and UserModel.methods.authorize is run on the result. If read is false, it will return an error. Authorization will be run for any fields with an authorize function specified. If read is false the field will be removed from the model in the result. The results are now returned.

PUT /users/:id

The query is executed and UserModel.methods.authorize is run on the result. If read is false, it will return an error. If write is false, it will return an error. Authorization will be run for any fields with an authorize function specified. If read is false for the field it will be excluded from the results. If write is false then it will be ignored in the reset unless they tried to write to said field in the PUT - if so an error will be returned. The results are now returned.

PATCH /users/:id

The query is executed and UserModel.methods.authorize is run on the result. If read is false, it will return an error. If write is false, it will return an error. Authorization will be run for any fields with an authorize function specified that are trying to be updated. If read is false an error will be returned. The results are now returned.

## LICENSE

(MIT License)

Copyright (c) 2013 Fractal <contact@wearefractal.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
