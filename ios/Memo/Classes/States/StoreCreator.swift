//
//  StoreCreator.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/05/25.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import ReSwift

let loggingMiddleware: Middleware = { dispatch, getState in
    return { dispatch in
        return { action in
            debugPrint("\(action)")
            return dispatch(action)
        }
    }
}

let reducers = CombinedReducer([
    MemoListState.Reducer(),
    MemoDetailState.Reducer()
//    AuthSessionState.Reducer(),
//    TimelineState.Reducer(),
//    LikedTweetsState.Reducer()
    ])

let store = Store<AppState>(reducer: reducers, state: nil, middleware: [loggingMiddleware])
