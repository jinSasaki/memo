const Error = {};

Error.pipeErrorRender = function(req, res, err) {
	console.log('Error.pipeErrorRender');
	console.log(err);
	return res.ng(err.code, {
		error: err
	});
};

Error.mongoose = function(code, err) {
	console.log(err);
	return {
		code: code,
		message: err.message
	};
};

Error.invalidParameter = {
	code: 400,
	message: 'INVALID_PARAMETER'
};

Error.unauthorized = {
	code: 401,
	message: 'Unauthorized'
};

Error.notFound = {
	code: 404,
	message: 'Not Found'
};

Error.conficts = {
	code: 409,
	message: 'Conflicts data'
}

module.exports = Error;
