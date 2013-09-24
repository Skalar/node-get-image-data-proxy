httpRequest = require 'request'
base64 = require 'base64-stream'

isAcceptableContentType = (contentType) ->
  ["image/gif", "image/jpeg", "image/jpg", "image/png", "image/tiff"].indexOf contentType is not -1


exports.checkParams = (request, response, next) ->
  if request.param('url')? and request.param('callback')
    request.imageUrl = decodeURIComponent request.param 'url'
    request.jsonpCallback = decodeURIComponent request.param 'callback'
    next()
  else
    next new Error "Must have url and callback!"



exports.getImageAndReturnBase64 = (request, response, next) ->
  imgRequest = httpRequest request.imageUrl

  imgRequest.on 'response', (imgResponse) ->
    contentType = imgResponse.headers["content-type"]

    if isAcceptableContentType contentType
      dataUrlHead =

      response.header 'Content-Type', 'application/javascript; charset=UTF-8'
      response.write request.jsonpCallback + '({"width":null,"height":null,"data":"'

      response.write dataUrlHead
      imgRequest.pipe(base64.encode()).pipe response

      imgRequest.on 'end', ->
        # Lucky for us that on end we can still write to the response stream.
        # Is this actually meant to work? We need to write a closing
        # JSON and JSONP method call to our stream.
        response.write '"})'
    else
      next new Error "Unexpected content type from server when fetching URL '#{request.imageUrl}'. content-type was: '#{contentType}'."



