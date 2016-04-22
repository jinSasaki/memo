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
    struct CreateMemoRequest: MemoRequestType {
        typealias Response = Memo
        
        var title: String
        var body: String
        var author: String
        
        var method: HTTPMethod {
            return .POST
        }
        
        var path: String {
            return "memo"
        }
        
        var parameters: [String : AnyObject] {
            return [
                "title": self.title,
                "body": self.body,
                "author": self.author
            ]
        }
    }
    
    static func createMemo(title title: String, body: String, author: String, handler: (Result<Memo, APIError>) -> Void) {
        let request = CreateMemoRequest(title: title, body: body, author: author)
        Session.sendRequest(request, handler: handler)
    }
}
