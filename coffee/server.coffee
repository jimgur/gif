do ( ->
  http        = require('http')
  GIFRequest  = require('./gifRequest.js')
  
  #GLOBAL.uploader = require('./uploader.js')
  
  http
    .createServer()
    .listen(8888, 'localhost')
    .on(
      'request',
      (req, res) ->
        GIFRequest.handleRequest(req, res)
    )
  
  # todo: what if the port is not available?
  console.log('************************************************')
  console.log('Vid2GIF Server started at http://localhost:8888!')
  console.log('************************************************')  
)