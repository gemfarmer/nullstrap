express = require('express')
app = express()
server = require('http').createServer(app)
passport = require 'passport'
config = require './config/config'
io = require('socket.io').listen(server)
fs = require 'fs'

# Connect to the DB
mongoose = require 'mongoose'
mongoose.connect(config.dbURI)

# Models
models = __dirname + '/models'
fs.readdirSync(models).forEach (file) ->
  require(models + '/'  +file)

# Passport Config
require('./config/passport')(passport, config)

# Express Config
require('./config/express')(app, passport)

# Routes
require('./config/routes')(app, passport)

# Socket Events
io.sockets.on 'connection', (socket) ->
  socket.emit 'hello', {data : 'Hi!'}

port = process.env.PORT or 3000
server.listen port, () -> 
  console.log "Server running on port " + port

