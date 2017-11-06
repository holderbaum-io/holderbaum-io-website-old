var express = require('express')
var app = express()

var user = process.env.GITHUB_USER
var apiToken = process.env.GITHUB_API_TOKEN

var port = process.env.PORT || 5000

app.get('/', function (req, res) {
  // Implement GitHub API call
})

app.listen(port, function () {
  console.log('App listening on port ' + port)
})
