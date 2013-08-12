uploader = require('../js/uploader')

describe 'ImgurUploader', ->
  
  it 'throws if any of constructor options are undefined', ->
    expect(-> new uploader()).toThrow()
    
    expect(-> new uploader({ filename : 'testfile' })).toThrow()
    expect(-> new uploader({ cb : -> })).toThrow()
    expect(-> new uploader({ filename : 'testfile', cb : -> })).not.toThrow()
  
  it 'aborts if the file exists at this.filename', ->
    up = new uploader({ filename : 'testfile1', cb : -> })
    spyOn(up, 'upload')
    up.ifFileExistsUpload()
    expect(up.upload).not.toHaveBeenCalled()
    
  # still don't know how to test modules within modules.