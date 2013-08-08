child_process = require('child_process')

class Vid2GIF

  MAXSIZE   : 1<<21 # bytes (2MB ~ imgur GIF limit)
  FPS       : 40
  maxHeight : 160
  
  
  constructor : (params) ->
    @[k] = v for k,v of params
    
  startConversion : ->
    cmd = [
      "bin/ffmpeg"                  # command name
      
      "-i #{@filename}"             # input file
      "-vf scale=-1:#{@maxHeight}"  # scale down to this height
      
      "-fs #{@MAXSIZE}"             # filesize limit
      #"-r #{@FPS}"                 # input? fps
      "#{@filename}.gif"            # output file
    ]
        
    child_process.exec(
      cmd.join(' '),
      { cwd : '.' },
      
      => @sendResponse()
    )
  
  
  uploadToImgur : ->
  
  
  sendResponse : ->
    console.log("GIF created for #{@filename}")
    @res.write(JSON.stringify({ text : "GIF created for #{@filename}" }))
    @res.end()
  
module.exports = Vid2GIF