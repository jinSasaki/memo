//
//  UpdateMemoRequest.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/23.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import APIKit
import Result

extension API {
    struct UpdateMemoRequest: MemoRequest {
        typealias Response = Memo
        var memo: Memo
        
        var method: HTTPMethod {
            return .put
        }
        
        var path: String {
            return "memo/" + self.memo.id
        }
        
        var parameters: [String : AnyObject] {
            return [
                "title": self.memo.title as AnyObject,
                "body": self.memo.body as AnyObject,
                "editor": self.memo.editor as AnyObject
            ]
        }
        
        init(memo: Memo) {
            self.memo = memo
        }
    }
    
    static func updateMemo(memo: Memo, handler: @escaping (Result<Memo, SessionTaskError>) -> Void) {
        let request = API.UpdateMemoRequest(memo: memo)
        Session.send(request, handler: handler)
    }

}
