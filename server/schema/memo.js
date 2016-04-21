var mongoose = require('../model/db.js'),
  uuid = require('node-uuid'),
  Schema = mongoose.Schema;

var MemoSchema = new Schema({
  deleted: {
    type: Boolean,
    default: false
  },
  title: String,
  body: String,
  author: String,
  editor: String,
  created: Number,
  updated: Number,
  uuid: String
});

MemoSchema.pre('save', function(next) {
  now = parseInt(Date.now() / 1000);
  this.updated = now;
  if (!this.created) this.created = now;
  if (!this.uuid) this.uuid = uuid.v4();
  next();
});

module.exports = MemoSchema;
