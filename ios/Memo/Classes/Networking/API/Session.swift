//
//  Session.swift
//  Memo
//
//  Created by Jin Sasaki on 2016/05/24.
//  Copyright © 2016年 Jin Sasaki. All rights reserved.
//

import Foundation
import APIKit
import RxSwift

extension Session {
    public static func rx_response<T: RequestType>(request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = sendRequest(request) { result in
                switch result {
                case .Success(let response):
                    observer.onNext(response)
                    observer.onCompleted()
                case .Failure(let error):
                    observer.onError(error)
                }
            }
            let t = task
            t?.resume()
            
            return AnonymousDisposable {
                task?.cancel()
            }
        }
    }
}
