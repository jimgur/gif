child_process = require('child_process')

class Vid2GIF

  MAXSIZE   : 1<<21 # bytes (2MB ~ imgur GIF limit)
  INPUT_FPS : 50
  FPS       : 40
  MAXHEIGHT : 200
  MAXWIDTH  : 400
    
  constructor : (params) ->
    console.log('Converting video to GIF...')
    
    @[k] = v for k,v of params

    cmd = [
      "bin/ffmpeg"                  # command name
      
      #"-r #{@INPUT_FPS}"           # set input frame rate (frameskip?)
      "-an"                         # ignore audio stream
      "-i #{@filename}"             # input file
            
      #"-vf scale=-1:#{@MAXHEIGHT}" # scale down to this height
      "-vf scale=#{@MAXWIDTH}:-1"   # scale down to this height
      
      #"-t 10"                      # 10s max duration
      
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
      => @cb("#{@filename}")
    )
    return
  
  findNumberOfFrames : (cb) ->
    # If we want to split the GIF into multiple GIFs to be uploaded into an album
    # find out where to split.
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
  
module.exports = Vid2GIF