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
    struct UpdateMemoRequest: MemoRequestType {
        typealias Response = Memo
        var memo: Memo
        
        var method: HTTPMethod {
            return .PUT
        }
        
        var path: String {
            return "memo/" + self.memo.id
        }
        
        var parameters: [String : AnyObject] {
            return [
                "title": self.memo.title,
                "body": self.memo.body,
                "editor": self.memo.editor
            ]
        }
        
        init(memo: Memo) {
            self.memo = memo
        }
    }
    
    static func updateMemo(memo memo: Memo, handler: (Result<Memo, SessionTaskError>) -> Void) {
        let request = API.UpdateMemoRequest(memo: memo)
        Session.sendRequest(request, handler: handler)
    }

}
