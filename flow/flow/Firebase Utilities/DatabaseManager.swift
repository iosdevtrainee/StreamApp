//
//  DatabaseManager.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation
import FirebaseFirestore

// Design Patterns

enum FireStoreType: String {
    case video
    case playlist
    case user
    case category
    case channel
}

protocol FirebaseConvertible {
    func convert() -> [String:String]
}

protocol Identifiable {
    var id: String { get set }
}

final class DatabaseManager {
    private init () { }
    
    public static var shared = DatabaseManager()
    
    private var fireStore: Firestore = {
        let db = Firestore.firestore()
        db.settings.isSSLEnabled = true
        return db
    }()
    
    public func create<T: Identifiable & FirebaseConvertible>(type:FireStoreType, instance:T) {
        
        fireStore.collection(type.rawValue).addDocument(data: instance.convert(),
                                                        completion: { (error) in
                if let error = error {
                    print("posing race failed with error: \(error)")
                } else {
//                    print("post created at ref: \(ref?.documentID ?? "no doc id")")
            }
        })
    }
    
    public func delete<T:Identifiable>(type:FireStoreType, instance:T){
        
    }
    
    public func update<T:Identifiable>(type:FireStoreType, instance:T){
        
    }
    
    public func fetch<T:Identifiable>(type:FireStoreType, instance:T){
        
    }
    
//    public let url = "gs://streamapp-87c97.appspot.com"
    
}
