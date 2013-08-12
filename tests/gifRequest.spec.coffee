GIFRequest = require('../js/gifrequest')
fs = require('fs')

describe 'GIFRequest', ->

  describe 'handleRequest', ->
    
    mockReq_noURL = 
      url : 'http://google.com?start=2m3s'
    
    mockReq_noSTART =
      url : 'http://google.com?url=http://blah'
    
    mockReq =
      url : 'http://google.com?url=http://blah&start=1m2s'
    
    mockRes =
      writeHead : ->
      write : ->
      end : ->
  
    it 'writes a header to allow for CORS', ->
      spyOn(mockRes, 'writeHead')
      GIFRequest.handleRequest(mockReq_noURL, mockRes)
      expect(mockRes.writeHead).toHaveBeenCalledWith(200, {
        'Access-Control-Allow-Origin'  : '*'
        'Access-Control-Allow-Methods' : 'GET,PUT,POST,DELETE,OPTIONS'
      })
      
    it 'responds with a JSON error if GET[url] is missing', ->
      spyOn(mockRes, 'write')
      GIFRequest.handleRequest(mockReq_noURL, mockRes)
      expect(mockRes.write).toHaveBeenCalledWith('{"error":"NO_URL","text":"No YouTube video specified!"}')

    it 'responds with a JSON error if GET[start] is missing', ->
      spyOn(mockRes, 'write')
      GIFRequest.handleRequest(mockReq_noSTART, mockRes)
      expect(mockRes.write).toHaveBeenCalledWith('{"error":"NO_STARTTIME","text":"Start time for video not given!"}')
      
    it 'calls downloadVideo if all params are OK', ->
      spyOn(GIFRequest, 'downloadVideo')
      GIFRequest.handleRequest(mockReq, mockRes)
      expect(GIFRequest.downloadVideo).toHaveBeenCalled()
      
  describe 'downloadVideo', ->
    
    # no idea how to spy on whether a module within a module was called!
    
    it 'calls the YTDL module', ->
      #GLOBAL.ytdl = ->
      # no idea how to spy on whether a module within a module was called!
      spyOn(GLOBAL, 'ytdl')
      GIFRequest.downloadVideo('http://blah', '1m2s',{})
      expect(GLOBAL.ytdl).toHaveBeenCalled()
    
    it 'sets an "end" callback for convertVideo', ->
      
    it 'pipes output to a temp video file', ->
    
  describe 'convertVideo', ->
  
    it 'calls the vid2gif module', ->
    
  describe 'uploadVideo', ->
  
    it 'calls the vid2gif module', ->
    
  describe 'deleteTempFiles', ->
  
    it 'deletes [file, file.gif, file.opt.gif] when called', ->
      fs.writeFileSync('testfile', 'this would be a movie', { flag : 'w+'})      
      fs.writeFileSync('testfile.gif', 'this would be a gif', { flag : 'w+'})      
      fs.writeFileSync('testfile.opt.gif', 'this would be an optimized gif', { flag : 'w+'})
      
      GIFRequest.deleteTempFiles('testfile')
      
      expect(fs.existsSync('testfile')).toBeFalsy()
      expect(fs.existsSync('testfile.gif')).toBeFalsy()
      expect(fs.existsSync('testfile.opt.gif')).toBeFalsy()
    
  describe 'sendResponse', ->
  
    it 'forwards any response from imgur upload', ->
      mockRes =
        write : ->
        end : ->
      
      mockImgurResponse =
        data : '12345'
        status : 200
      
      spyOn(mockRes, 'write')
      
      GIFRequest.sendResponse(mockImgurResponse, mockRes)
      
      expect(mockRes.write).toHaveBeenCalledWith('{"data":"12345","status":200}')