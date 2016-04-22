//
//  Memos.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/23.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import Himotoki

struct Memos {
    var memos: [Memo]
}

extension Memos: Decodable {
    static func decode(e: Extractor) throws -> Memos {
        return try Memos(
            memos: e <|| "memos"
        )
    }
}
