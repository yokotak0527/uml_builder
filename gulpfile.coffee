'use strict'
gulp       = require('gulp')
path       = require('path')
server     = require('gulp-webserver')
run        = require('gulp-run')
plumber    = require('gulp-plumber')
serverRoot = path.join(process.cwd(),'dest/')
watchDir   = path.join(process.cwd(),'src/')
destDir    = path.join(process.cwd(),'dest/')
watchFiles = path.join(watchDir,'**/*.pu')
conf       =
	server :
		livereload : true
		host       : '127.0.0.1'
		port       : '8008'
	plantuml :
		path   : path.join(process.cwd(),'bin/plantuml.jar')
		option : [
			'-tpng'
			'-charset UTF-8'
		]

# ==============================================================================
# 処理
# ==============================================================================
makeUML = (file_path)->
	dest_path = file_path.replace(watchDir,'')
	if dest_path.match(/\//) == null
		dest_path = destDir
	else
		console.log dest_path
		dest_path = dest_path.replace(/\/[a-z0-9_\-\^\~\]\:\;\[\(\)\S]+\.pu/i,'')
		dest_path = path.join(destDir,dest_path,'/')
	cmd  = "java -jar '#{conf.plantuml.path}'"
	cmd += " -o '#{dest_path}' '#{file_path}'"
	for val in conf.plantuml.option then cmd += " #{val}"
	gulp.src(file_path)
		.pipe(plumber())
		.pipe(run(cmd))
	return

# ==============================================================================
# gulp tasks
# ==============================================================================
gulp.task('up',->
	gulp.src(serverRoot)
		.pipe(server(conf.server))
	return
)
# ------------------------------------------------------------------------------
gulp.task('watch',()->
	gulp.watch(watchFiles,(e)->
		makeUML(e.path)
		return
	)
	return
)
# ==============================================================================
gulp.task 'default', ['up', 'watch']
