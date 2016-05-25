//
//  MemoListAction.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/05/25.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import ReSwift

extension MemoListState {
    struct RequestGetMemoListAction: Action {}
    struct ResponseGetMemoListAction: Action {
        let memos: [Memo]
    }
    
    struct ErrorGetMemoListAction: Action {
        let error: ErrorType
    }

    struct RequestDeleteMemoAction: Action {
        let memoId: String
    }
    struct ResponseDeleteMemoAction: Action {
        let memoId: String
    }
    struct ErrorDeleteMemoAction: Action {
        let error: ErrorType
    }
}


extension MemoListState {
    static func fetchMemo() -> Store<AppState>.AsyncActionCreator {
        return { (state, store, callback) in
            store.dispatch(RequestGetMemoListAction())
            API.getMemos(handler: { (result) in
                switch result {
                case .Success(let memos):
                    callback { _, _ in ResponseGetMemoListAction(memos: memos.memos) }
                case .Failure(let error):
                    callback { _,_ in ErrorGetMemoListAction(error: error) }
                }
            })
        }
    }
    
    static func deleteMemo(memoId: String) -> Store<AppState>.AsyncActionCreator {
        return { (state, store, callback) in
            store.dispatch(RequestDeleteMemoAction(memoId: memoId))
            API.deleteMemo(memoId: memoId, handler: { (result) in
                switch result {
                case .Success(_):
                    callback { _, _ in ResponseDeleteMemoAction(memoId: memoId) }
                case .Failure(let error):
                    callback { _,_ in ErrorDeleteMemoAction(error: error) }
                }
            })
        }
    }
}
