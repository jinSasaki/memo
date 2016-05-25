//
//  MemoListState.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/05/25.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import ReSwift
enum FetchStatus {
    case Initial, Refresh, Fetching, Success, Error
}

struct MemoListState {
    var fetchStatus: FetchStatus  = .Initial
    var memos: [Memo] = []
    var error: ErrorType?
    var alertMessage: String?
}
