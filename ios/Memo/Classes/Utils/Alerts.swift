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
    class func handleError(error: ErrorType) {
        switch error {
        case let error as NSError:
            AlertBar.showError(error)
        case let error as APIError:
            AlertBar.show(.Error, message: "\(error)")
        default:
            print(error)
        }
    }
    class func success(message: String) {
        AlertBar.show(.Success, message: message)
    }
}
