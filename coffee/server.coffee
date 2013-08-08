do ( ->
  GLOBAL.http     = require('http')
  GLOBAL.fs       = require('fs')
  GLOBAL.ytdl     = require('ytdl')
  GLOBAL.url      = require('url')
  GLOBAL.ERRORS   = require('./ERRORS.js')  
  GLOBAL.vid2gif  = require('./vid2gif.js') 
  
  requestListener = (req, res) ->
    
    # http://www.youtube.com/watch?v=R-HsWxMq36s
    console.log("Request received for #{req.url}")
    
    # CORS
    res.writeHead(200, {
      'Access-Control-Allow-Origin'  : '*'
      'Access-Control-Allow-Methods' : 'GET,PUT,POST,DELETE,OPTIONS'
    })    
    
    GET = url.parse(req.url, true).query
    missingParams = null
    
    # Check if any params are missing
    if !(GET.url?)
      missingParams = JSON.stringify(ERRORS.NO_URL)
    else if !(GET.start?)
      missingParams = JSON.stringify(ERRORS.NO_STARTTIME)
    
    # Throw JSON error if so and abort
    if missingParams
      res.write(missingParams)
      res.end()
      return
      
    filename = "tmp/#{ (Math.random() * 1e6)>>0 }.flv"
    
    # Create a new converter instance
    gif      = new vid2gif({
      res      : res
      filename : filename
    })
    
    # Initiate download
    dl = ytdl(GET.url, { quality : 'lowest' })
    
    # Trigger the converter once the download is complete
    dl.on('end', -> gif.startConversion())
    
    # Pipe the stream into the video file
    dl.pipe(fs.createWriteStream(filename))
    
    return
  
  http.createServer().listen(8888, 'localhost').on('request', requestListener)
)