module.exports = (error, request, response, next) ->
  response.send 500,
    error: error.toString()
