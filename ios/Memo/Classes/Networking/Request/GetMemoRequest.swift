//
//  GetMemoRequest.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/23.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import APIKit
import Result

extension API {
    struct GetMemosRequest: MemoRequest {
        typealias Response = Memos
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "memo"
        }
    }
    
    static func getMemos(handler: @escaping (Result<Memos, SessionTaskError>) -> Void) {
        let request = API.GetMemosRequest()
        Session.send(request, handler: handler)
    }
}
