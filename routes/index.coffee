httpRequest = require 'request'
base64 = require 'base64-stream'
CombinedStream = require 'combined-stream'

dataUrlHeadFor = (contentType) -> "data:" + contentType + ";base64,"
isAcceptableContentType = (contentType) ->
  ["image/gif", "image/jpeg", "image/jpg", "image/png", "image/tiff"].indexOf contentType is not -1


exports.checkAndAssignParams = (request, response, next) ->
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
      response.header 'Content-Type', 'application/javascript; charset=UTF-8'

      combinedStream = CombinedStream.create()

      combinedStream.append request.jsonpCallback + '({"width":null,"height":null,"data":"'
      combinedStream.append dataUrlHeadFor contentType
      combinedStream.append imgRequest.pipe(base64.encode())
      combinedStream.append '"})'

      combinedStream.pipe response
    else
      next new Error "Unexpected content type from server when fetching URL '#{request.imageUrl}'. content-type was: '#{contentType}'."



