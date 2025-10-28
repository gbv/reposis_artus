module.exports = function (grunt) {
    grunt.initConfig({
        globalConfig: {
            moduleDirectory: grunt.option('moduleDirectory')
        },
        uglify: {
            mir: {
                mangle: false,
                options: {
                    sourceMap: {
                        includeSources: true
                    }
                },
                files: {
                    '<%= globalConfig.moduleDirectory %>/target/classes/META-INF/resources/js/mir/select-doctype.min.js':
                        '<%= globalConfig.moduleDirectory %>/src/main/resources/META-INF/resources/js/mir/select-doctype.js',

                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-uglify');

    grunt.registerTask('default', ['uglify']);
};