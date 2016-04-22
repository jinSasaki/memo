var express = require('express'),
	router = express.Router(),
	memoRouter = require('./v1/memo.js'),
	Error = require('../model/error.js');

express.response.ok = function(code, json) {
	return this.status(code).json(json || {});
};

express.response.ng = function(code, json) {
	return this.status(code).json(json || {});
};

router.use(function(req, res, next) {
	req.jonathanSession = {};
	res.set({
		'Content-Type': 'application/json',
		'Access-Control-Allow-Origin': '*',
		'Access-Control-Allow-Headers': 'X-Session-Token,X-Platform,Content-Type',
		'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE'
	});
	next();
});

router.use('/memo', memoRouter);

router.use(function(req, res, next) {
	return Error.pipeErrorRender(req, res, Error.notFound);
});

module.exports = router;
