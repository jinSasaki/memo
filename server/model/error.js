const Error = {};

Error.pipeErrorRender = function(req, res, err) {
	console.log('Error.pipeErrorRender');
	console.log(err);
	return res.ng(err.code, {
		error: err.error
	});
};

Error.mongoose = function(code, err) {
	console.log(err);
	return {
		code: code,
		error: {
			message: err.message
		}
	};
};

Error.invalidParameter = {
	code: 400,
	error: {
		message: 'INVALID_PARAMETER'
	}
};

Error.unauthorized = {
	code: 401,
	error: {
		message: 'Unauthorized'
	}
};

Error.notFound = {
	code: 404,
	error: {
		message: 'Not Found'
	}
};

Error.conficts = {
	code: 409,
	error: {
		message: 'Conflicts data'
	}
}

module.exports = Error;
