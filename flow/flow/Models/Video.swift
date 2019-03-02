//
//  Video.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation

struct Video: FirebaseStorable, Identifiable {
    var collection: Collection = .video
    public var id: String
    public let videoURL: String
    
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

struct Playlist: FirebaseStorable, Identifiable {
    public var id: String
    public let collection: Collection = .playlist
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

struct Channel: FirebaseStorable, Identifiable {
    public var id: String
    public let collection: Collection = .channel
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
