//
//  AppState.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/05/25.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    var list = MemoListState()
    var detail = MemoDetailState()
}
