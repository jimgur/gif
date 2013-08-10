fs        = require('fs')
url       = require('url')
ytdl      = require('ytdl')
vid2gif   = require('./vid2gif.js')
uploader  = require('./uploader.js')

STATUS =
  NO_URL : 
    error : 'NO_URL'
    text  : 'No YouTube video specified!'
  
  NO_STARTTIME :
    error : 'NO_STARTTIME'
    text  : 'Start time for video not given!'

# Just a namespace for functions. No need to have a class here.
GIFRequest =
  
  handleRequest : (req, res) ->
    # CORS
    res.writeHead(200, {
      'Access-Control-Allow-Origin'  : '*'
      'Access-Control-Allow-Methods' : 'GET,PUT,POST,DELETE,OPTIONS'
    })
    
    GET = url.parse(req.url, true).query
    missingParams = null
    
    # Check if any params are missing
    if !(GET.url?)
      missingParams = JSON.stringify(STATUS.NO_URL)
    else if !(GET.start?)
      missingParams = JSON.stringify(STATUS.NO_STARTTIME)
    
    # Throw JSON error if so and abort
    if missingParams
      res.write(missingParams)
      res.end()
      return
      
    console.log("Request received for YouTube video @ #{GET.url}...")
    @downloadVideo(GET.url, GET.start, res)
    
  downloadVideo : (url, start, res) ->
    console.log('Downloading the video from YouTube...')
    
    filename = "tmp/#{ (Math.random() * 1e6)>>0 }.flv"
    
    # Initiate download
    dl = ytdl(url, { quality : '36', start : start }) # '36' is standard def
    
    # Trigger the converter once the download is complete
    dl.on('end', => @convertVideo(filename, res))
    
    # Pipe the stream into the video file
    dl.pipe(fs.createWriteStream(filename))
    
  
  convertVideo : (filename, res) ->
    new vid2gif({
      cb        : (gifpath) => @uploadVideo(gifpath, res)
      filename  : filename
    })

  uploadVideo : (filename, res) ->
    new uploader({
      filename : filename
      cb : (response) =>
        @deleteTempFiles(filename)
        @sendResponse(response, res)
    })

  deleteTempFiles : (filename) ->
    console.log('Deleting temp files...')
    fs.unlinkSync(file) for file in [
      "#{filename}"
      "#{filename}.gif"
      "#{filename}.opt.gif"
    ]
    return

  sendResponse : (imgurResponse, res) ->
    console.log("Forwarding upload response...")
    if res?
      console.log("Response received was: #{JSON.stringify(imgurResponse)}")
      res.write(JSON.stringify(imgurResponse))
      res.end()
      console.log("Transaction complete.")
    else
      throw 'No request response object was given!'
    
module.exports = GIFRequest