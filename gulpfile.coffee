'use strict'
gulp     = require('gulp')
path     = require('path')
server   = require('gulp-webserver')

serverRoot = path.join(process.cwd(),'dest')
watchDir   = path.join(process.cwd(),'src')
destDir    = path.join(process.cwd(),'dest')
watchFiles = path.join(watchDir,'**/*.pu')
conf       =
	server :
		livereload       : true
		host             : '127.0.0.1'
		port             : '8008'
		open             : true
		directoryListing : true
	plantuml :
		path    : path.join(process.cwd(),'bin/plantuml.jar')
		prefix  : 'pu'
		option  : [
			'-tpng'
			'-charset UTF-8'
		]
	exec :
		option :
			continueOnError : true
			pipeStdout      : true
		report :
			err    : true
			stderr : false
			stdout : false

# ==============================================================================
# 処理
# ==============================================================================
makeUML = (filePath)->
	exec     = require('gulp-exec')
	fileDir  = path.dirname(filePath).replace(watchDir,'')
	file_name = path.basename(filePath,".#{conf.plantuml.prefix}")
	dest_path = path.join(destDir,fileDir)
	cmd  = "java -jar '#{conf.plantuml.path}'"
	cmd += " -o '#{dest_path}' '#{filePath}'"
	for val in conf.plantuml.option then cmd += " #{val}"
	gulp.src(filePath).pipe(exec(cmd,conf.exec.option))
		.pipe(exec.reporter(conf.exec.report))
	return

# ==============================================================================
# gulp tasks
# ==============================================================================
gulp.task('check',->
	exec = require('child_process').exec
	exec("java -jar '#{conf.plantuml.path}' -checkversion",(err,stdout,stderr)->
		if !err and stdout then console.log stdout
		return
	)
	return
)
# ------------------------------------------------------------------------------
gulp.task('up',->
	gulp.src(serverRoot).pipe(server(conf.server))
	return
)
# ------------------------------------------------------------------------------
gulp.task('watch',->
	gulp.watch(watchFiles,(e)->
		makeUML(e.path)
	)
	return
)
# ==============================================================================
gulp.task 'default', ['check','up','watch']
