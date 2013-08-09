child_process = require('child_process')
#oauth         = require('oauth')
http          = require('http')
fs            = require('fs')
restler       = require('restler')

class Vid2GIF

  MAXSIZE   : 1<<21 # bytes (2MB ~ imgur GIF limit)
  INPUT_FPS : 50
  FPS       : 40
  MAXHEIGHT : 200
  MAXWIDTH  : 400
    
  constructor : (params) ->
    @[k] = v for k,v of params
    
  startConversion : ->
    console.log('Converting video to GIF...')
    
    cmd = [
      "bin/ffmpeg"                  # command name
      
      #"-r #{@INPUT_FPS}"           # set input frame rate (frameskip?)
      "-an"                         # ignore audio stream
      "-i #{@filename}"             # input file
            
      #"-vf scale=-1:#{@MAXHEIGHT}" # scale down to this height
      "-vf scale=#{@MAXWIDTH}:-1"   # scale down to this height
      
      "-fs #{@MAXSIZE}"             # filesize limit (FFMPEG has a defect here!)
      #"-r #{@FPS}"                 # input? fps
      
      "#{@filename}.gif"            # output file
    ]
   
    cmd = cmd.join(' ')
    
    child_process.exec(
      cmd,
      { cwd : '.' },
      => @optimizeGif()
    )
    return
  
  optimizeGif : ->
    # todo: get the FPS of the video and set the gif delay accordingly
    console.log('Optimizing GIF...')
    
    cmd = [
      "gifsicle"                    # command name
      
      "-k 64"                       # reduce to 64 colors
      "--delay 7"                   # set frame delay ; FPS = 100 / delay
      "-O2"                         # optimize GIFs by storing changes only
      
      "#{@filename}.gif"            # input file
      "-o"
      "#{@filename}.opt.gif"        # output file
    ]
    child_process.exec(
      cmd.join(' '),
      { cwd : '.' },
      => @authWithImgur()
    )
    return
  
  findNumberOfFrames : (cb) ->
    cmd = [
      "gifsicle"                    # command name
      
      "-I"                          # INFO
      "#{@filename}.opt.gif"        # output file
      "|"
      "grep"                        # grep for relevant info
      "-c"                          # count number of frame messages
      "'+ image #'"
    ]
    
    child_process.exec(
      cmd.join(' '),
      { cwd : '.' },
      (error, stdout, stderr) =>
        numFrames = parseInt(stdout.toString())
        cb(numFrames)
    )
    return
  
  measureFileSize : ->
    # todo: use this to split files by Math.ceil(currentFile size / maxFilesize)
  
  authWithImgur : ->
    console.log('Authing with Imgur...')
    
    @AUTHHEADER = { "Authorization" : "Client-ID #{@IMGURKEY}" }
    @uploadToImgur()
    
    # This is not really needed if we're not uploading to a user's account.
    return
    OAuth2 = oauth.OAuth2
    
    @oauth = new OAuth2(
      @IMGURKEY,
      @IMGURSECRET,
      'https://api.imgur.com/',
      null,
      'oauth2/token',
      null
    )
    
    @oauth.getOAuthAccessToken(
      '',
      { 'grant_type' : 'client_credentials' },
      (e, access_token, refresh_token, results) =>
        # Anonymous uploading...
        @AUTHHEADER = { "Authorization" : "Client-ID #{@IMGURKEY}" }
        @uploadToImgur()
    )
    return
  
  uploadToImgur : ->
    console.log('Uploading to Imgur...')
    
    fs.stat("#{@filename}.opt.gif", (err, stats) =>
      restler.post(
        "https://api.imgur.com/3/image",
        {
          headers   : @AUTHHEADER
          multipart : true
          data      :
            "image" : restler.file("#{@filename}.opt.gif", null, stats.size, null, "image/gif")
        }
      ).on(
        "complete", (data) =>
          @deleteTmpFiles()
          @sendResponse(data)
      )
    )
    return
  
  deleteTmpFiles : ->
    console.log('Deleting temp files...')
    
    fs.unlinkSync(file) for file in [
      "#{@filename}"
      "#{@filename}.gif"
      "#{@filename}.opt.gif"
    ]
    return
  
  sendResponse : (uploadResponse) ->
    jsonResponse = JSON.stringify(uploadResponse)
    console.log("Forwarding upload response...")
    
    @res.write(jsonResponse)
    @res.end()
    console.log("Transaction complete.")
  
module.exports = Vid2GIF