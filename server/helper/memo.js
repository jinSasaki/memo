var _ = {};

_.formatMemo = function(memo) {
  return {
    id: memo.uuid,
    title: memo.title,
    body: memo.body,
    author: memo.author,
    editor: memo.editor,
    created: memo.created,
    updated: memo.updated
  };
}

_.formatMemos = function(memos) {
  return memos.map(memo => _.formatMemo(memo));
}

module.exports = _;
