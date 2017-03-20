//
//  CreateMemoRequest.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/23.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import APIKit
import Result

extension API {
    struct CreateMemoRequest: MemoRequest {
        typealias Response = Memo
        
        var title: String
        var body: String
        var author: String
        
        var method: HTTPMethod {
            return .post
        }
        
        var path: String {
            return "memo"
        }

        var parameters: Any? {
            return [
                "title": self.title,
                "body": self.body,
                "author": self.author
            ]
        }
    }
    
    static func createMemo(title: String, body: String, author: String, handler: @escaping (Result<Memo, SessionTaskError>) -> Void) {
        let request = CreateMemoRequest(title: title, body: body, author: author)
        Session.send(request, handler: handler)
    }
}
