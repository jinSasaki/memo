//
//  DeleteMemoRequest.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/23.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import APIKit
import Result

extension API {
    struct DeleteMemoRequest: MemoRequestType {
        typealias Response = EmptyResponse
        var memoId: String
        
        var method: HTTPMethod {
            return .DELETE
        }
        
        var path: String {
            return "memo/" + self.memoId
        }
        
        init(memoId: String) {
            self.memoId = memoId
        }
        
    }
    
    static func deleteMemo(memoId memoId: String, handler: (Result<EmptyResponse, APIError>) -> Void) {
        let request = API.DeleteMemoRequest(memoId: memoId)
        Session.sendRequest(request, handler: handler)
    }
}
