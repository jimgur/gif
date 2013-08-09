do ( ->
  GLOBAL.http     = require('http')
  GLOBAL.fs       = require('fs')
  GLOBAL.ytdl     = require('ytdl')
  GLOBAL.url      = require('url')
  GLOBAL.ERRORS   = require('./ERRORS.js')  
  GLOBAL.vid2gif  = require('./vid2gif.js')
  
  #GLOBAL.uploader = require('./uploader.js')
  
  requestListener = (req, res) ->

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

      
    console.log("Request received for Youtube video @ #{GET.url}...")
    
    filename = "tmp/#{ (Math.random() * 1e6)>>0 }.flv"
    
    # Create a new converter instance
    gif      = new vid2gif({
      res         : res
      filename    : filename
      IMGURKEY    : 'a811ef40c9dcf16'
    })
    
    # Initiate download
    dl = ytdl(GET.url, { quality : 'lowest' }) # '17' for something slightly better than lowest
    
    # Trigger the converter once the download is complete
    dl.on('end', -> gif.startConversion())
    
    # Pipe the stream into the video file
    dl.pipe(fs.createWriteStream(filename))
    
    return
  
  http.createServer().listen(8888, 'localhost').on('request', requestListener)
  console.log('Server started at http://localhost:8888!')
  console.log('****************************************')
)