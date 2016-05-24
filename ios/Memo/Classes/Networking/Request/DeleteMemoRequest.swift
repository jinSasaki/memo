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
import RxSwift

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
    
    static func deleteMemo(memoId memoId: String) -> Observable<EmptyResponse> {
        let request = API.DeleteMemoRequest(memoId: memoId)
        return Session.rx_response(request)
    }
}
