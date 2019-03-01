//
//  StorageManager.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation
import FirebaseStorage

protocol StorageManagerDelegate: AnyObject {
    func storageManager(_ storageManager:StorageManager, didReceiveError: FirebaseError)
    func storageManager(_ storageManager:StorageManager, didReceiveURL: URL)
}

enum ContentType: String {
    case video = "application/mp4"
    case image = "image/png"
}

final class StorageManager {
    
    public weak  var delegate: StorageManagerDelegate?
    
    private init () { }
    public static var shared = StorageManager()
    private lazy var rootRef: StorageReference = {
        return Storage.storage().reference()
    }()
    
    public func store(data:Data, user:AuthUser, contentType:ContentType) {
        let path = "videos_\(user.id)"
        let storageRef = rootRef.child(path)
        let metadata = StorageMetadata()
        metadata.contentType = contentType.rawValue
        let uploadTask = storageRef.putData(data, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                if let error = error {
                    self.delegate?.storageManager(self ,
                                                  didReceiveError: FirebaseError
                                                    .storageUploadError(error.localizedDescription))
                }
                self.delegate?
                    .storageManager(self, didReceiveError: FirebaseError.storageUploadError("uh oh"))
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.delegate?
                        .storageManager(self, didReceiveError: FirebaseError.storageUploadError(error.localizedDescription))
                } else if let url = url {
                    self.delegate?.storageManager(self, didReceiveURL: url)
                }
            })
        }
        uploadTask.observe(.failure) { (storageTaskSnapshot) in
            print("failure...")
        }
        uploadTask.observe(.pause) { (storageTaskSnapshot) in
            print("pause...")
        }
        uploadTask.observe(.progress) { (storageTaskSnapshot) in
            print("progress...")
        }
        uploadTask.observe(.resume) { (storageTaskSnapshot) in
            print("resume...")
        }
        uploadTask.observe(.success) { (storageTaskSnapshot) in
            print("success...")
        }
    }
    
}
