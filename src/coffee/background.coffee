define 'background', [ 'stuff' ], (Stuff) ->

  document.addEventListener('DOMContentLoaded', ->
    divs = document.querySelectorAll('div')
    for div in divs
      div.addEventListener('click', clickHandler)
  )