//
//  User.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation

struct User: FirebaseConvertible, Identifiable {
    var id: String
    
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

struct AuthUser: FirebaseConvertible, Identifiable {
    var id: String
    
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
    
//    public let id: String
    public let email: String
}
