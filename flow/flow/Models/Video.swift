//
//  Video.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation

struct Video: FirebaseStorable, Identifiable {
    
    init(id:String = UUID().uuidString,
         url:URL, collection: Collection = .video,
         ownerId:String, title:String){
        self.id = id
        self.url = url
        self.collection = collection
        self.ownerId = ownerId
        self.title = title
    }
    
    init(document: Document) {
        self.collection = .video
        self.id = document.id
        let urlString = document.data["url"] as? String ?? "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.mp4"
        self.url = URL(string: urlString)!
        self.title = document.data["title"] as? String ?? ""
        self.ownerId = document.data["ownerId"] as? String ?? ""
    }
    
    var collection: Collection = .video
    public var id: String
    public let url: URL
    public let title: String
    public let ownerId: String
    func convert() -> [String : String] {
        return ["id":id,
                "title":title,
                "ownerID": ownerId,
                "url":self.url.absoluteString]
    }
    
    
}

struct Playlist: FirebaseStorable, Identifiable {
    
    init(id:String = UUID().uuidString,
         collection:Collection = .channel,
         title:String, ownerID:String,
         videoIDs: [String] = []){
        self.id = id
        self.collection = collection
        self.title = title
        self.ownerID = ownerID
        self.videoIDs = videoIDs
    }
    
    init(document: Document) {
        self.id = document.id
        self.collection = .playlist
        self.ownerID = document.data["ownerID"] as? String ?? ""
        self.title = document.data["title"] as? String ?? ""
        let firebaseIds = document.data["videoIDs"] as? String ?? ""
        self.videoIDs = firebaseIds.components(separatedBy: ",")
    }
    public var id: String
    public let ownerID: String
    public let title:String
    public let videoIDs: [String]
    public let collection: Collection
    func convert() -> [String : String] {
        return ["id":self.id,
                "ownerID":ownerID,
                "title":title,
                "videoIDs": videoIDs.joined(separator: ","),
                "":self.id,
                "":self.id,
                "":self.id]
    }
}

struct Channel: FirebaseStorable, Identifiable {
    
    init(id:String = UUID().uuidString,
         collection:Collection = .channel,
         title:String, userID:String,
         likes: Int = 0, comments:[String] = [],
         url:String, viewers:Int){
        self.id = id
        self.collection = collection
        self.title = title
        self.userID = userID
        self.likes = likes
        self.comments = comments
        self.url = url
        self.viewers = viewers
    }
    
    init(document: Document) {
        self.id = document.id
        self.collection = .channel
        self.viewers = document.data["viewers"] as? Int ?? 0
        self.likes = document.data["likes"] as? Int ?? 0
        self.title = document.data["title"] as? String ?? ""
        self.userID = document.data["viewers"] as? String ?? ""
        self.url = document.data["url"] as? String ?? ""
        let firebaseComments = document.data["comments"] as? String ?? ""
        self.comments = firebaseComments.components(separatedBy: separator)
    }
    public let userID: String
    public let title: String
    public let url: String
    public let separator: String = "_,_"
    public var titleEncoded: String {
        return title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    public var likes: Int
    public var comments: [String]
    public var id: String
    public var viewers:Int
    public let collection: Collection
    func convert() -> [String : String] {
        return ["id":id,
                "title":title,
                "userID":userID,
                "likes":likes.description,
                "comments":comments.joined(separator: separator),
                "url":url,
                "viewers":viewers.description]
    }
    
    
}
