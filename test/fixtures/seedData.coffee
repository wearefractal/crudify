Faker = require "Faker"
db = require "./connection"
Seedling = require "seedling"
async = require "async"

seed = module.exports = new Seedling db,

  User: ->
    create = (score) ->
      return {
        name: Faker.Name.findName()
        score: score
        time: Math.floor(Math.random()*1000)
      }
    create i for i in [1..30]

  Comment: ->
    create = ->
      return {
        user: seed.embed "User"
        body: Faker.Lorem.paragraph()
      }
    create i for i in [1..30]

  
  Post: ->
    create = ->
      return {
        title: Faker.Lorem.words()
        body: Faker.Lorem.paragraphs()
        user: seed.embed "User"
      }
    create i for i in [1..30]

###
# Create the best friend for user 
###
seed.post "create", (next) ->
  createBestFriend = (user, cb) ->
    loop # do/while
      bestFriend = seed.embed("User")
      break unless bestFriend._id is user._id
    user.bestFriend = bestFriend
    user.friends.push bestFriend._id unless bestFriend._id in user.friends
    bestFriend.friends.push user._id unless user._id in bestFriend.friends
    user.save (err) -> bestFriend.save cb
  async.eachSeries seed.collection['User'], createBestFriend, next

###
# Create friends for user 
###
seed.post "create", (next) ->
  createFriends = (user, cb) ->
    for i in [1..4]
      loop # do/while
        friend = seed.embed("User")
        break unless friend._id is user._id or friend._id in user.friends
      user.friends.push friend._id unless friend._id in user.friends
      friend.friends.push user._id unless user._id in friend.friends
    user.save (err) -> friend.save cb
  async.eachSeries seed.collection['User'], createFriends, next

###
# Create friends for user 
###
seed.post "create", (next) ->
  createComment = (post, cb) ->
    for i in [1..4]
      loop # do/while
        comment = seed.embed("Comment")
        break unless comment._id in post.comments
      post.comments.push comment._id
    post.save cb
  async.eachSeries seed.collection['Post'], createComment, next
