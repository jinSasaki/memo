//
//  EmptyResponse.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/23.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import Himotoki

struct EmptyResponse {
    
}

extension EmptyResponse: Decodable {
    static func decode(e: Extractor) throws -> EmptyResponse {
        return EmptyResponse()
    }
}
