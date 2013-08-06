# Yay this finally works! The path was bad previously!

require [ '../src/js/background' ], (Background) ->
  describe 'foo', ->
    it 'blah blah blahs', ->
      expect(0).toEqual(0)
