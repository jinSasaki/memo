var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var Auth = require('./model/auth.js');
var Error = require('./model/error.js');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
	extended: false
}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use(function(req, res, next) {
	var headers = req.headers;
	var appToken = headers['x-app-token'] || '';
	var application = Auth.applications[appToken];
	if (!application) {
		return Error.pipeErrorRender(req, res, Error.unauthorized);
	}
	console.info(`Connected by ${application}`);
	if (headers['x-app-version']) console.info(`App Version: ${headers['x-app-version']}`);
	if (headers['x-platform']) console.info(`Platform: ${headers['x-platform']}`);
	next();
})
app.use('/api/v1', require('./routes/v1.js'));

// catch 404 and forward to error handler
app.use(function(req, res, next) {
	var err = new Error('Not Found');
	err.status = 404;
	next(err);
});

// error handlers

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
	res.status(err.status || 500);
	res.render('error', {
		message: err.message,
		error: {}
	});
});


module.exports = app;
