//
//  User.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation

struct User: FirebaseStorable, Identifiable {
    
    init(id:String = UUID().uuidString,
         collection:Collection = .user,
         playlistIDs:[String] = [],
         email:String){
        self.id = id
        self.collection = collection
        self.playlistIDs = playlistIDs
        self.email = email
    }
    
    init(document: Document) {
        self.id = document.id
        self.collection = .user
        self.email = document.data["email"] as? String ?? ""
        let firebaseIDs = document.data["playlistIDs"] as? String ?? ""
        self.playlistIDs = firebaseIDs.components(separatedBy: ",")
    }
    
    public var id: String
    public let collection: Collection
    public let email: String
    public let playlistIDs: [String]
    func convert() -> [String : String] {
        return ["id":id,
                "email":email,
                "playlistIDs":playlistIDs.joined(separator: ","),
                "":self.id,
                "":self.id,
                "":self.id,
                "":self.id,
                "":self.id]
    }
    
    
}

struct AuthUser: Identifiable {
    public var id: String
    public let email: String
}
