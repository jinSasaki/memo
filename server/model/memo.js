var mongoose = require('./db.js'),
  schema = require('../schema/memo.js'),
  MemoHelper = require('../helper/memo.js'),
  Error = require('./error.js');

var _ = {},
  model = mongoose.model('Memo', schema),
  ObjectId = mongoose.Schema.ObjectId;

_.pGetAll = function() {
  console.log('Memo.pGetAll');
  var query = {
    deleted: false
  };
  return new Promise(function(resolve, reject) {
    model.find(query)
      .sort({
        updated: -1
      })
      // .lean()
      .exec(function(err, memos) {
        if (err) return reject(Error.mongoose(500, err));
        resolve(memos);
      });
  });
};

_.pGetOne = function(memoId) {
  console.log('Memo.pGetOne');
  var query = {
    uuid: memoId,
    deleted: false
  };
  console.log(query);
  return new Promise(function(resolve, reject) {
    model.findOne(query, function(err, memo) {
      if (err) return reject(Error.mongoose(500, err));
      if (!memo) return reject(Error.invalidParameter);

      resolve(memo);
    });
  });
};

_.pCreate = function(body) {
  console.log('Memo.pCreate');
  var title = body.title || '';
  var author = body.author || '';
  var body = body.body || '';
  var query = {
    title: title,
    body: body,
    author: author,
    editor: author
  };
  return new Promise(function(resolve, reject) {
    new model(query)
      .save(function(err, createdMemo) {
        if (err) return reject(Error.mongoose(500, err));
        if (!createdMemo) return reject(Error.invalidParameter);
        model.findOne(createdMemo, function(err, memo) {
          resolve(memo);
        });
      });
  });
};

_.pUpdate = function(memoId, body) {
  console.log('Memo.pUpdate');
  return _.pGetOne(memoId).then(memo => {
    return new Promise(function(resolve, reject) {
      if (body.title) memo.title = body.title;
      if (body.body) memo.body = body.body;
      if (body.editor) memo.body = body.editor;
      memo.save(function(err, updatedMemo) {
        if (err) return reject(Error.mongoose(500, err));
        if (!updatedMemo) return reject(Error.invalidParameter);
        model.findOne(updatedMemo, function(err, memo) {
          resolve(memo);
        });
      });
    });
  })
}

_.pDelete = function(memoId) {
  console.log('Memo.pDelete');
  console.log(memoId);
  return _.pGetOne(memoId).then(memo => {
    return new Promise(function(resolve, reject) {
      memo.deleted = true;
      memo.save(function(err, updatedMemo) {
        if (err) return reject(Error.mongoose(500, err));
        if (!updatedMemo) return reject(Error.invalidParameter);
        model.findOne(updatedMemo, function(err, memo) {
          console.log(memo);
          resolve(memo);
        });
      });
    });
  })
}

_.pipeSuccessRender = function(req, res, memo) {
  console.log('Memo.pipeSuccessRender\n');
  return res.ok(200, {
    memo: MemoHelper.formatMemo(memo)
  });
};

_.pipeCreateRender = function(req, res, memo) {
  console.log('Memo.pipeCreatedRender\n');
  return res.ok(201, {
    memo: MemoHelper.formatMemo(memo)
  });
};

_.pipeDeleteRender = function(req, res, memo) {
  console.log('Memo.pipeDeleteRender\n');
  return res.ok(204, {});
};

_.pipeSuccessRenderAll = function(req, res, memos) {
  console.log('Memo.pipeSuccessRendeAll\n');
  return res.ok(200, {
    memos: MemoHelper.formatMemos(memos)
  });
};

module.exports = _;
