module.exports = (grunt) ->
  "use strict"

  require("jit-grunt") grunt, {
    haml: "grunt-haml-php"
  }

  # Project configuration
  grunt.initConfig {

    # Metadata
    pkg: grunt.file.readJSON "package.json"
    banner: "/*! <%= pkg.name %> - v<%= pkg.version %>\n" + "<%= pkg.homepage ? \"* \" + pkg.homepage + \"\\n\" : \"\" %>" + "* Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= pkg.author.name %> <<%= pkg.author.homepage %>>" + " */\n\n"

    # Target-specific file lists and/or options go here.
    clean: ["app/themes/theme-juice/**/*.{php,js,map}"]

    browserify: {
      dist: {
        options: {
          global: yes
          banner: "<%= banner %>"
        }
        files: [{
          src: [
            "src/themes/theme-juice/scripts/**/*.coffee"
            "src/themes/theme-juice/scripts/**/*.js"
          ]
          dest: "app/themes/theme-juice/assets/scripts/main.js"
        }]
      }
    }
    compass: {
      dist: {
        options: {
          cssDir: "app/themes/theme-juice/assets/css"
          httpPath: "/"
          outputStyle: "expanded"
          require: ["flint", "sass-globbing", "graphite", "SassyExport", "stampy"]
          sassDir: "src/themes/theme-juice/styles"
        }
      }
    }
    copy: {
      templates: {
        files: [{
          expand: yes
          cwd: "src/themes"
          src: ["**/*.php"]
          dest: "app/themes/"
          rename: (dest, src) -> dest + src.replace(/\/templates\//, "/")
        }]
      }
    }
    cssmin: {
      dist: {
        files: {
          "app/themes/theme-juice/assets/css/main.min.css" : ["app/themes/theme-juice/assets/css/main.css"]
        }
      }
    }
    haml: {
      templates: {
        options: {
          enableDynamicAttributes: no
        }
        files: [{
          expand: yes
          cwd: "src/themes"
          src: ["**/*.haml"]
          dest: "app/themes/"
          ext: ".php"
          rename: (dest, src) -> dest + src.replace(/\/templates\//, "/")
        }]
      }
    }
    uglify: {
      options: {
        banner: "<%= banner %>"
      }
      dist: {
        src: ["app/themes/theme-juice/assets/scripts/main.js"]
        dest: "app/themes/theme-juice/assets/scripts/main.min.js"
      }
    }
    imagemin: {
      dist: {
        options: {
          optimizationLevel: 3
          svgoPlugins: [{
            removeViewBox: no
          }]
        }
        files: [{
          expand: yes
          cwd: "app/themes/theme-juice/assets/images/"
          src: ["*.{png,jpg,gif}"]
          dest: "app/themes/theme-juice/assets/images"
        }, {
          expand: yes
          cwd: "app/themes/theme-juice/assets/svg/"
          src: ["*.{svg}"]
          dest: "app/themes/theme-juice/assets/images"
        }]
      }
    }
    watch: {
      gruntfile: {
        files: [
          "Gruntfile.coffee"
          "Gruntfile.js"
        ]
        tasks: ["default"]
      }
      scripts: {
        files: [
          "src/themes/**/*.coffee"
          "src/themes/**/*.js"
        ]
        tasks: ["scripts"]
        options: {
          livereload: yes
        }
      }
      styles: {
        files: [
          "src/themes/**/*.sass"
          "src/themes/**/*.scss"
        ]
        tasks: ["styles"]
        options: {
          livereload: yes
        }
      }
      templates: {
        files: [
          "src/themes/**/*.haml"
          "src/themes/**/*.php"
        ]
        tasks: ["newer:haml", "newer:copy:templates"]
        options: {
          livereload: yes
        }
      }
    }
  }

  # Default task
  grunt.registerTask "default", [
    "clean"
    "templates"
    "styles"
    "scripts"
    "watch"
  ]

  # Templates
  grunt.registerTask "templates", [
    "copy:templates"
    "haml"
  ]

  # Styles
  grunt.registerTask "styles", [
    "compass"
    "cssmin"
  ]

  # Scripts
  grunt.registerTask "scripts", [
    "browserify"
    "uglify"
  ]
