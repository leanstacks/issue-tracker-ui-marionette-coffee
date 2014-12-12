module.exports = (grunt) ->

  # Project Configuration
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      src : [ 'dist/*' ]
    coffee:
      options:
        bare: true
      compile:
        files: 'dist/assets/app/js/app-<%= pkg.version %>.js': [ 'src/main/app/coffee/Application.coffee',
          'src/main/app/coffee/**/*.coffee' ]
    connect:
      server:
        options:
          base: 'dist/'
          port: 9000
    copy:
      main:
        files: [
          expand: true
          cwd: 'src/main/app/'
          src: [ '*' ]
          dest: 'dist/'
          filter: 'isFile'
        ,
          expand: true
          cwd: 'src/main/'
          src: [ 'app/**', '!app/**/*.html', '!app/coffee/**', '!app/templates/**' ]
          dest: 'dist/assets/'
        ,
          expand: true
          src: [ 'lib/**' ]
          dest: 'dist/assets/'
        ]
    jst:
      compile:
        options:
          namespace: 'IssueTrackerTemplates'
          processName: (filePath) ->
            filePath.replace(/^src\/main\/app\/templates\//, '')
                    .replace(/\.html$/,'')
        files:
          'dist/assets/app/js/app-templates-<%= pkg.version %>.js' : 'src/main/app/templates/*.html'
    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
        sourceMap: true
        sourceMapName: 'dist/assets/app/js/app-<%= pkg.version %>.map'
      main:
        files:
          'dist/assets/app/js/app-<%= pkg.version %>.min.js': 'dist/assets/app/js/app-<%= pkg.version %>.js'
    watch:
      src:
        files: [ 'src/**/*', 'lib/**/*' ]
        tasks: [ 'dist' ]

  # Load Plugins
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jst'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # Define Tasks
  grunt.registerTask 'default', [ 'clean', 'copy', 'jst', 'coffee', 'uglify' ]
  grunt.registerTask 'dist', [ 'clean', 'copy', 'jst', 'coffee', 'uglify' ]
  grunt.registerTask 'run', [ 'default', 'connect:server', 'watch' ]
