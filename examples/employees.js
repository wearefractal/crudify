var mongoose = require('mongoose');
var express = require('express');
var crudify = require('../');

// Create the db connection
var db = mongoose.createConnection('mongodb://localhost/business');

// Create our schema
var EmployeeSchema = new mongoose.Schema({
  name: {
      type: String,
      required: true
  },
  status: {
      type: String,
      enum: ['online','away','offline'],
      default: 'offline'
  }
});

// Add the model into db
var Employee = db.model('Employee', EmployeeSchema);

// Create the HTTP server
var app = express();
app.use(express.bodyParser());

// Expose our models from the database and add it to the HTTP server
var api = crudify(db);
api.expose('Employee');
api.hook(app);

// Listen to port 8080
app.listen(8080);

console.log("Server listening on 8080");