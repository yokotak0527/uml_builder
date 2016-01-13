'use strict'
plantuml =
	path : '/Users/WPMC4/local/bin/plantuml.jar'
	conf :
		format : '-tsvg'
gulp          = require('gulp')
path          = require('path')
server        = require('gulp-webserver')
run           = require('gulp-run')

serverRoot    = path.join(process.cwd(),'dest/')
watchDir      = path.join(process.cwd(),'src/')
watchFiles    = path.join(watchDir,'**/*.pu')
dest          = path.join(process.cwd(),'dest')

# ==============================================================================
# 処理
# ==============================================================================
makeUML = (file_path)->
	dest_path = file_path.replace(watchDir,'').replace(/\/[a-z0-9_\-\^\~\]\:\;\[\(\)\S]+\.pu/i,'')
	dest_path = path.join(dest,dest_path,'/')
	console.log dest_path
	cmd  = "java -jar #{plantuml.path}"
	cmd += " -o #{dest_path} #{file_path}"
	for key,val of plantuml.conf then cmd += " #{val}"
	gulp.src(file_path)
		.pipe(run(cmd))
	return

# ==============================================================================
# gulp タスク
# ==============================================================================
# サーバー立ち上げ
# ------------------------------------------------------------------------------
gulp.task('up',->
	gulp.src(serverRoot)
		.pipe(server(
			livereload : true,
			host       : '127.0.0.1'
			port       : '8008'
		))
	return
)

# ------------------------------------------------------------------------------
# 監視
# ------------------------------------------------------------------------------
gulp.task('watch',()->
	gulp.watch(watchFiles,(e)->
		makeUML(e.path)
		return
	)
	return
)

# ------------------------------------------------------------------------------
# デフォルトタスク
# ------------------------------------------------------------------------------
gulp.task 'default', ['up', 'watch']
