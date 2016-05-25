//
//  MemoListReducer.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/05/25.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import ReSwift

extension MemoListState {
    struct Reducer: ReSwift.Reducer {
        typealias ReducerStateType = AppState
        
        func handleAction(action: Action, state: ReducerStateType?) -> ReducerStateType {
            let prevState = state ?? AppState()
            let prevMemoListState = prevState.list
            var nextState = prevState
            var nextMemoListState = nextState.list

            nextMemoListState.alertMessage = nil
            switch action {
            case is RequestGetMemoListAction:
                nextMemoListState.fetchStatus = .Fetching
                
            case let action as ResponseGetMemoListAction:
                nextMemoListState.fetchStatus = .Success
                nextMemoListState.memos = prevMemoListState.fetchStatus == .Refresh ? action.memos :  action.memos //TweetsReducerHelper.mergeTweets(prevMemoListState.tweets, nextTweets: action.tweets)
                
            case let action as ErrorGetMemoListAction:
                nextMemoListState.fetchStatus = .Error
                nextMemoListState.error = action.error
                
            case is RequestDeleteMemoAction:
                nextMemoListState.fetchStatus = .Fetching

            case let action as ResponseDeleteMemoAction:
                nextMemoListState.fetchStatus = .Success
                nextMemoListState.memos = prevMemoListState.memos.filter({ $0.id != action.memoId })
                nextMemoListState.alertMessage = "Success delete"
                
            case let action as ErrorDeleteMemoAction:
                nextMemoListState.fetchStatus = .Error
                nextMemoListState.error = action.error
                
            default:
                break
            }
            
            nextState.list = nextMemoListState
            return nextState
            
        }
    }
}
