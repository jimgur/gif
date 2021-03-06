restler = require('restler')
fs      = require('fs')

class ImgurUploader

  IMGURKEY : 'a811ef40c9dcf16' # Client-ID as required by Imgur API
  
  constructor : (params) ->
    @[k] = v for k,v of params
    
    console.log('Uploading to Imgur...')

    if !(@filename?) then throw 'Upload cannot proceed without an input file!'
    if !(@cb?)       then throw 'Callback required for upload!'
    
    @ifFileExistsUpload()
    return
  
  ifFileExistsUpload : ->
    if fs.existsSync("#{@filename}.opt.gif")
      fs.stat("#{@filename}.opt.gif", (err, stats) => @upload(stats.size))
    return
  
  upload : (size) ->
    console.log("UPLOADING #{@filename}.opt.gif -- SIZE #{size}")
    
    restler.post(
      "https://api.imgur.com/3/image",
      {
        headers   : { "Authorization" : "Client-ID #{@IMGURKEY}" }
        multipart : true
        data      :
          "image" : restler.file("#{@filename}.opt.gif", null, size, null, "image/gif")
      }
    ).on("complete", @cb)
    return
    
  
module.exports = ImgurUploader