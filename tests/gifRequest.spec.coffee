GIFRequest = require('../js/gifrequest')

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
      GIFRequest.handleRequest(mockReq, mockRes)
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