//
//  MemoDetailState.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/05/25.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import ReSwift

struct MemoDetailState {
    var fetchStatus: FetchStatus  = .Initial
    var memo: Memo?
    var error: ErrorType?
    var alertMessage: String?
    var canDismiss: Bool = true
}
