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
import RxSwift

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
    
    static func getMemos() -> Observable<Memos> {
        let request = API.GetMemosRequest()
        return Session.rx_response(request)
    }
}
