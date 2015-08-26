var gulp = require('gulp');
var deploy = require('gulp-gh-pages');
var uglify = require('gulp-uglify');
var elm = require('gulp-elm');
var rename = require('gulp-rename');


gulp.task('prepare_html', function(){
    gulp.src('index.html').pipe(gulp.dest("./dist"));
});

gulp.task('elm-init', elm.init);

gulp.task('prepare_js', ['elm-init'], function() {
    gulp.src('Main.elm')
    .pipe(elm())
    .pipe(uglify())
    .pipe(rename('elm.js'))
    .pipe(gulp.dest('./dist'));
});

gulp.task('deploy', ['prepare_html', 'prepare_js'], function(){
    gulp.src('./dist/**/*').pipe(deploy());
});
