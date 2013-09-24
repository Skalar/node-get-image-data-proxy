express = require "express"
http = require "http"
routes =  require "./routes"
errorHandler =  require "./error_handler"
app = express()

app.set "port", process.env.PORT or 5000
app.use express.logger("dev")
app.use app.router
app.use errorHandler

app.get '/', routes.checkParams, routes.getImageAndReturnBase64

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
