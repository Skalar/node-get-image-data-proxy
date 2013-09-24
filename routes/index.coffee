httpRequest = require 'request'
base64 = require 'base64-stream'

isAcceptableContentType = (contentType) ->
  ["image/gif", "image/jpeg", "image/jpg", "image/png", "image/tiff"].indexOf contentType is not -1


exports.checkParams = (request, response, next) ->
  if request.param('url')? and request.param('callback')
    request.imageUrl = request.param 'url'
    request.callback = request.param 'callback'
    next()
  else
    next new Error "Must have url and callback!"



exports.getImageAndReturnBase64 = (request, response, next) ->
  imgRequest = httpRequest request.imageUrl


  imgRequest.on 'response', (imgResponse) ->
    contentType = imgResponse.headers["content-type"]

    if isAcceptableContentType contentType
      dataUrlHead = "data:" + contentType + ";base64,"
      response.write dataUrlHead
      imgRequest.pipe(base64.encode()).pipe response
    else
      next new Error "Unexpected content type from server when fetching URL '#{request.imageUrl}'. content-type was: '#{contentType}'."



