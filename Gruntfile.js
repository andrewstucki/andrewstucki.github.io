module.exports = function(grunt) {
  require('load-grunt-tasks')(grunt);

  var packageInfo = grunt.file.readJSON('package.json');
  var bowerConf = grunt.file.readJSON('.bowerrc');

  grunt.initConfig({
    bower: bowerConf,
    pkg: packageInfo,

    jshint: {
      files: ['Gruntfile.js', 'src/**/*.js', 'test/**/*.js'],
      options: {
        globals: {
          jQuery: true
        }
      }
    },

    watch: {
      files: ['<%= jshint.files %>'],
      tasks: ['jshint']
    },

    copy: {
      fonts: {
        files: [{
          expand: true,
          cwd: '<%= bower.directory %>/bootstrap/fonts',
          src: ['**'],
          dest: 'fonts/'
        }, {
          expand: true,
          cwd: '<%= bower.directory %>/font-awesome/fonts',
          src: ['**'],
          dest: 'fonts/'
        }],
      },
      html: {
        files: {
          "index.html": "src/pages/index.html"
        }
      }
    },

    less: {
      development: {
        options: {
          paths: [
            'src/less',
            '<%= bower.directory %>/bootstrap/less',
            '<%= bower.directory %>/font-awesome/less',
          ],
          plugins: [
            new(require('less-plugin-clean-css'))({
              keepSpecialComments: 0
            })
          ]
        },
        files: {
          "style.css": "src/less/style.less"
        }
      }
    },

    imagemin: {
      images: {
        files: [{
          expand: true,
          cwd: 'src/images',
          src: ['**/*.{png,jpg,gif}'],
          dest: 'images/'
        }]
      }
    },

    concat: {
      script: {
        src: [
          '<%= bower.directory %>/jquery/dist/jquery.min.js',
          '<%= bower.directory %>/Chart.js/Chart.min.js',
          '<%= bower.directory %>/bootstrap/dist/js/bootstrap.min.js',
          'src/js/script.js'
        ],
        dest: 'script.js'
      }
    },

    uglify: {
      dist: {
        files: {
          'script.min.js': ['<%= concat.script.dest %>']
        }
      }
    }
  });

  grunt.registerTask('default', [
    'jshint',
    'copy:fonts',
    'concat',
    'uglify',
    'less',
    'imagemin',
    'copy:html'
  ]);

};
