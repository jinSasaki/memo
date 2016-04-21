var mongoose = require('mongoose'),
	config = require('../config.js');

mongoose.connect(`mongodb://${config.DB_HOST}:${config.DB_PORT}/${config.DB_NAME}`);

module.exports = mongoose;