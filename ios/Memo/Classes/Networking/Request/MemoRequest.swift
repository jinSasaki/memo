//
//  MemoRequest.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/21.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

protocol MemoRequestType: RequestType {
}

extension MemoRequestType {
    var baseURL: NSURL {
        return NSURL(string: "http://127.0.0.1:3000/api/v1")!
    }
    
    var path: String {
        return ""
    }
    
    var headerFields: [String : String] {
        return [
            "X-App-Token": "F6FAC3AE-0A00-4724-982C-0B0B5F0C00FA",
            "X-App-Version": "1.0.0",
            "X-Platform": "ios"
        ]
    }
}

extension MemoRequestType where Response: Decodable {
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Self.Response {
        return try decodeValue(object)
    }
}
