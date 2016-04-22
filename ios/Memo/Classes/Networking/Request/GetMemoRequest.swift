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
    struct GetMemosRequest: MemoRequestType {
        typealias Response = Memos
        
        var method: HTTPMethod {
            return .GET
        }
        
        var path: String {
            return "memo"
        }
    }
    
    static func getMemos(handler handler: (Result<Memos, APIError>) -> Void) {
        let request = API.GetMemosRequest()
        Session.sendRequest(request, handler: handler)
    }
}
