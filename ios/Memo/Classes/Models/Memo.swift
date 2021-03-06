//
//  Memo.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/22.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import Himotoki

struct Memo {
    var id: String
    var title: String
    var body: String
    var author: String
    var editor: String
    var created: Int
    var updated: Int
}

extension Memo: Decodable {
    static func decode(_ e: Extractor) throws -> Memo {
        return try Memo(
            id: e <| "id",
            title: e <| "title",
            body: e <| "body",
            author: e <| "author",
            editor: e <| "editor",
            created: e <| "created",
            updated: e <| "updated"
        )
    }
}
