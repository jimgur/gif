vid2gif = require('../js/vid2gif')
fs      = require('fs')

describe 'Vid2GIF', ->
  
  it 'uses a ffmpeg binary to convert a video into a gif', ->
    # this is more of an integration test case than a unit test case
    
    new vid2gif({ filename : 'tests/tmp/test.flv', cb : ->
      expect(fs.existsSync('tests/tmp/test.flv.gif')).toBeTruthy()
      expect(fs.existsSync('tests/tmp/test.flv.opt.gif')).toBeTruthy()
      
      fs.unlinkSync('tests/tmp/test.flv.gif')
      fs.unlinkSync('tests/tmp/test.flv.opt.gif')
    })
    
    