module.exports = (grunt) ->

  grunt.initConfig({
    pkg : grunt.file.readJSON('package.json')
    
    requirejs :
      compile :
        options :
          wrap                   : true
          baseUrl                : './src/js/'
          out                    : './dist/vid2gif.js'
          optimize               : 'uglify'
          findNestedDependencies : false
          name                   : 'almond'   # use almond instead of requireJS for faster AMD API
          include                : 'background'
    
    shell :
      copyManifest :
        command : 'cp src/manifest.json dist/'
      
      cleanJS :
        command : 'rm -rf src/js ; rm -rf dist '
      
      copyAlmond :
        command : 'cp src/almond.js src/js/almond.js'
    
      compileCoffee :
        command : 'coffee -b -c --output src/js/ src/coffee/'
    
      test :
        command : 'jasmine-node --verbose --runWithRequireJs --coffee src/tests/'
        
    jasmine_node :
      forceExit       : true
      match           : '.'
      matchall        : false
      extensions      : 'js'
      specNameMatcher : 'spec'
  })
  
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-contrib-requirejs')
  grunt.loadNpmTasks('grunt-jasmine-node')
  
  grunt.registerTask('default', [
    'shell:cleanJS'
    'shell:compileCoffee'
    'shell:copyAlmond'
    'requirejs'
    'shell:copyManifest'
  ])
    
  return
