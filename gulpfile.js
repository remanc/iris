var gulp = require('gulp')
  , coffee = require('gulp-coffee');

gulp.task('compile-coffee', function () {
  gulp.src('./lib/*.coffee')
  .pipe(coffee())
  .pipe(gulp.dest('./target'))
});
