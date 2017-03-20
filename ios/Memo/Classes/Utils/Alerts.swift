//
//  Alerts.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/04/22.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import AlertBar
import APIKit

class Alerts {
    class func handleError(_ error: Error) {
        AlertBar.show(error: error)
    }
    class func success(_ message: String) {
        AlertBar.show(.success, message: message)
    }
}
