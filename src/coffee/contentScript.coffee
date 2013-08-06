require [
  './videoDownloader'
], (VideoDownloader) ->
  embeds = document.getElementsByTagName('embed')
  hasMoviePlayer = false
  (
    if embed.id is 'movie_player'
      hasMoviePlayer = true
      break
  ) for embed in embeds
    
  if hasMoviePlayer
    alert(VideoDownloader)

  return
  