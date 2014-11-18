module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'
  grunt.initConfig
    watch:
      files: ['*.coffee'],
      tasks: ['coffee']

    coffee:
      compile:
        options:
          sourceMap: false
        files: [
            expand: true,
            cwd: './',
            src: ['*.coffee'],
            dest: './',
            ext: '.js'
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
