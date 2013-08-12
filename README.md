vid2gif
=======

- node utility to generate a GIF from a youtube video via command line
- Stitch these frames together to create a GIF, which is then uploaded to Imgur
- Jim @ imgur

## Compile and run the node server
    
    $ scripts/run
    

## Running the unit tests
You'll need `nodeunit` to run the tests.

    Install nodeunit
    $ npm install -g nodeunit
       
    $ nodeunit
    
## Bookmarklet for YouTube pages

See `bookmarklet.txt`.

Or copy and paste this :
    
    javascript:!function(){function d(a){var b=[];for(var c in a)b.push(encodeURIComponent(c)+"="+encodeURIComponent(a[c]));return"?"+b.join("&")}function e(a){if(null!=a){var b=a.callback;delete a.callback;var c=new XMLHttpRequest;c.open("GET","http://localhost:8888"+d(a),!0),c.onreadystatechange=function(){4===c.readyState&&200===c.status&&null!=b&&b(JSON.parse(c.responseText))},c.send()}}function f(a,b){for(var c in b)a.setAttribute(c,b[c])}function g(a,b){for(var c in b)a.style[c]=b[c]}function m(a){var b={height:"100%",display:"block"},c="";a.success?(c+="<img src="+a.data.link+"><br><br>",c+="Direct Link <br> <a target='_blank' href="+a.data.link+"><code>"+a.data.link+"</code></a><br><br>",c+="Delete Link <br> <a target='_blank' href='http://imgur.com/delete/"+a.data.deletehash+"'><code>http://imgur.com/delete/"+a.data.deletehash+"</code></a><br><br>"):c+="<span style='color:#c33'>ERROR :( <code>"+a.data.error+"</code></span><br><br>",i.innerHTML=c;for(var d in b)i.style[d]=b[d];i.appendChild(l)}function n(a){i.innerText=a}function o(){i.style.display="none"}var a=document.getElementById("video-player"),b=document.getElementById("movie_player"),c=a||b;if(c){var h=document.body,i=document.createElement("div");g(i,{position:"fixed",bottom:0,left:0,width:"100%",height:"120px",background:"#111",textAlign:"center",verticalAlign:"middle",zIndex:"9999",color:"#ccc",paddingTop:"2em",fontSize:"1.5em"}),i.innerHTML="Start time : ";var j=document.createElement("input");f(j,{type:"text",value:"0m0s"});var k=document.createElement("input");f(k,{type:"button",value:"Make GIF!"});var l=document.createElement("input");f(l,{type:"button",value:"close"}),i.appendChild(j),i.appendChild(k),h.appendChild(i),l.onclick=o,n("Hold on! Making a GIF of this video..."),e({url:window.location.href.split("&")[0],start:prompt("start time","0m0s"),callback:m})}}();

## Links and resources
- https://en.wikipedia.org/wiki/YouTube#Quality_and_codecs