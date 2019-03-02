//
//  User.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation

struct User: FirebaseStorable, Identifiable {
    public var id: String
    public let collection: Collection = .user
    func convert() -> [String : String] {
        return ["id":self.id,
                "":self.id,
                "":self.id,
                "":self.id,
                "":self.id,
                "":self.id,
                "":self.id,
                "":self.id]
    }
    
    
}

struct AuthUser {
    public let id: String
    public let email: String
}
