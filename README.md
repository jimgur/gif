vid2gif
=======

- node utility to generate a GIF from a youtube video via command line
- Stitch these frames together to create a GIF, which is then uploaded to Imgur
- Jim @ imgur

## Compile and run the node server
    
    $ ./run
    

## Running the unit tests

    $ scripts/test
    
## Bookmarklet for Youtube pages

todo : uglify this.

javascript:

(function(){
    var player1 = document.getElementById('video-player');
    var player2 = document.getElementById('movie_player');
    var PLAYER = player1 || player2;
    if(PLAYER) {
        
       
        function JSON2GET(obj){
            var a = [];
            for (var d in obj) { a.push(encodeURIComponent(d) + "=" + encodeURIComponent(obj[d])); }
            return '?'+a.join("&");
        }
        
        function sendGIFRequest(options) {
            var defaults = {
                url   : window.location.href.split('&')[0],
                start : '0:0'
            };
            options = options || defaults;
            
            var xhr = new XMLHttpRequest();
            xhr.open( "GET", 'http://localhost:8888'+JSON2GET(options), false );
            xhr.onreadystatechange = function(){
                if(xhr.readyState === 4 && xhr.status === 200) {
                    alert(options.callback);
                    if(options.callback != null) {
                        options.callback(JSON.parse(xhr.responseText));
                    }
                }
            };
            xhr.send();
        }
        
        function showMsg(jsonResponse) {
            alert(jsonResponse.text);
        }
        
        function showDialog(jsonResponse) {
        
        }
        
        sendGIFRequest({
            url      : window.location.href.split('&')[0],
            start    : '0:0',
            callback : showMsg
        });
        
    }
})();