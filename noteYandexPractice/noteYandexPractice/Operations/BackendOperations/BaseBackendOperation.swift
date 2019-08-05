//
//  BaseBackendOperation.swift
//  noteYandexPractice
//
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
//

import Foundation

class BaseBackendOperation: AsyncOperation {
    override init() {
        super.init()
    }
}

enum NetworkError {
    case unreachable
}

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}
