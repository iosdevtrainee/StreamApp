//
//  Video.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation

struct Video: FirebaseConvertible, Identifiable {
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

struct Playlist: FirebaseConvertible, Identifiable {
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

struct Channel: FirebaseConvertible, Identifiable {
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
