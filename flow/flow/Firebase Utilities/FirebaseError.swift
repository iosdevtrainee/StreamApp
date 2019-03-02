//
//  FirebaseError.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation

enum FirebaseError: Error {
    case storageUploadError(String)
    case signOutError(Error)
    case createDocumentError(Error)
    case updateDocumentError(Error)
    case fetchDocumentError(Error)
    case noDocumentError(String)
    case deleteDocumentError(Error)
}
