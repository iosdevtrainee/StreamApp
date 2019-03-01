//
//  DatabaseManager.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation
import FirebaseFirestore
final class DatabaseManager {
    private init () { }
    public static var fireStore: Firestore = {
        let db = Firestore.firestore()
        db.settings.isSSLEnabled = true
        return db
    }()
    
    
    
}
