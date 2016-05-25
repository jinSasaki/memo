//
//  MemoDetailReducer.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/05/25.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import ReSwift

extension MemoDetailState {
    struct Reducer: ReSwift.Reducer {
        typealias ReducerStateType = AppState
        
        func handleAction(action: Action, state: ReducerStateType?) -> ReducerStateType {
            let prevState = state ?? AppState()
            var nextState = prevState
            var nextDetailState = nextState.detail
            
            nextDetailState.alertMessage = nil
            switch action {
            case is RequestCreateMemoAction:
                nextDetailState.fetchStatus = .Fetching
                
            case let action as ResponseCreateMemoAction:
                nextDetailState.fetchStatus = .Success
                nextDetailState.memo = action.memo
                nextDetailState.alertMessage = "Success create: " + action.memo.title
                nextDetailState.canDismiss = true
                
            case let action as ErrorCreateMemoAction:
                nextDetailState.fetchStatus = .Error
                nextDetailState.error = action.error
                
            case is RequestUpdateMemoAction:
                nextDetailState.fetchStatus = .Fetching
                
            case let action as ResponseUpdateMemoAction:
                nextDetailState.fetchStatus = .Success
                nextDetailState.memo = action.memo
                nextDetailState.alertMessage = "Success update: " + action.memo.title
                nextDetailState.canDismiss = true
                
            case let action as ErrorUpdateMemoAction:
                nextDetailState.fetchStatus = .Error
                nextDetailState.error = action.error
                
            case is EnableDismissAction:
                nextDetailState.canDismiss = true
            case is DisableDismissAction:
                nextDetailState.canDismiss = false
                
            default:
                break
            }
            
            nextState.detail = nextDetailState
            return nextState
            
        }
    }
}
