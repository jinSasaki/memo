//
//  MemoDetailAction.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/05/25.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import ReSwift

extension MemoDetailState {
    struct RequestCreateMemoAction: Action {
        let title: String
        let body: String
        let author: String
    }
    struct ResponseCreateMemoAction: Action {
        let memo: Memo
    }
    struct ErrorCreateMemoAction: Action {
        let error: ErrorType
    }

    struct RequestUpdateMemoAction: Action {
        let memo: Memo
    }
    struct ResponseUpdateMemoAction: Action {
        let memo: Memo
    }
    struct ErrorUpdateMemoAction: Action {
        let error: ErrorType
    }
    
    struct EnableDismissAction: Action {}
    struct DisableDismissAction: Action {}
}


extension MemoDetailState {
    static func createMemo(title title: String, body: String, author: String) -> Store<AppState>.AsyncActionCreator {
        return { (state, store, callback) in
            store.dispatch(RequestCreateMemoAction(title: title, body: body, author: author))
            API.createMemo(title: title, body: body, author: author, handler: { (result) in
                switch result {
                case .Success(let memo):
                    callback { _, _ in ResponseCreateMemoAction(memo: memo) }
                case .Failure(let error):
                    callback { _,_ in ErrorCreateMemoAction(error: error) }
                }
            })
        }
    }

    static func updateMemo(memo: Memo) -> Store<AppState>.AsyncActionCreator {
        return { (state, store, callback) in
            store.dispatch(RequestUpdateMemoAction(memo: memo))
            API.updateMemo(memo: memo, handler: { (result) in
                switch result {
                case .Success(let memo):
                    callback { _, _ in ResponseUpdateMemoAction(memo: memo) }
                case .Failure(let error):
                    callback { _,_ in ErrorUpdateMemoAction(error: error) }
                }
            })
        }
    }
    
    static func changeCanDismiss(enabled: Bool) -> Store<AppState>.AsyncActionCreator {
        return { (state, store, callback) in
            if enabled {
                store.dispatch(EnableDismissAction())
            } else {
                store.dispatch(DisableDismissAction())
            }
        }
    }
}
