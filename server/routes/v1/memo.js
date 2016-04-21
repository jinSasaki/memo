var express = require('express'),
  router = express.Router(),
  Memo = require('../../model/memo.js'),
  Error = require('../../model/error.js');

router.get('/', function(req, res) {
  Memo.pGetAll()
    .then(memos => Memo.pipeSuccessRenderAll(req, res, memos))
    .catch(error => Error.pipeErrorRender(req, res, error))
})

router.post('/', function(req, res) {
  Memo.pCreate(req.body)
    .then(memo => Memo.pipeCreateRender(req, res, memo))
    .catch(error => Error.pipeErrorRender(req, res, error))
})

router.put('/:memoId', function(req, res) {
  Memo.pUpdate(req.params.memoId, req.body)
    .then(memo => Memo.pipeSuccessRender(req, res, memo))
    .catch(error => Error.pipeErrorRender(req, res, error))
})

router.delete('/:memoId', function(req, res) {
  Memo.pDelete(req.params.memoId)
    .then(memo => Memo.pipeDeleteRender(req, res, memo))
    .catch(error => Error.pipeErrorRender(req, res, error))
})

module.exports = router;
