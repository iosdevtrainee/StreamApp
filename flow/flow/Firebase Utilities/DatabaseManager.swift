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

enum Collection: String {
    case video
    case playlist
    case user
    case category
    case channel
}

//TODO: Make this a seperate Codable Object i.e. FireBaseEncoder / FireBaseDecoder
protocol FirebaseStorable {
    func convert() -> [String:String]
    var collection:Collection { get }
    init(document:Document)
}

protocol Identifiable {
    var id: String { get set }
}

protocol DatabaseManagerDelegate: AnyObject {
    func databaseManager(_ databaseManager:DatabaseManager, didReceiveError error:FirebaseError)
    func databaseManager(_ databaseManager:DatabaseManager, didCreateDocument id:DocumentID)
    func databaseManager(_ databaseManager:DatabaseManager, didUpdateDocument id:DocumentID)
    func databaseManager(_ databaseManager:DatabaseManager, didReceiveDocument document:Document)
    func databaseManager(_ databaseManager:DatabaseManager, didReceiveDocuments documents:[Document])
    func databaseManager(_ databaseManager:DatabaseManager, didDeleteDocument success:Bool)
}

extension DatabaseManagerDelegate {
    func databaseManager(_ databaseManager:DatabaseManager, didCreateDocument id:DocumentID){
        
    }
    func databaseManager(_ databaseManager:DatabaseManager, didUpdateDocument id:DocumentID){
        
    }
    func databaseManager(_ databaseManager:DatabaseManager, didReceiveDocument document:Document){
        
    }
    func databaseManager(_ databaseManager:DatabaseManager, didReceiveDocuments documents:[Document]){
        
    }
    func databaseManager(_ databaseManager:DatabaseManager, didDeleteDocument success:Bool){
        
    }
}

//TODO: Consider changing this specification to a type
typealias Document = (id:String, data:[String:Any])
typealias DocumentID = String

final class DatabaseManager {
    private init () { }
    
    public static var shared = DatabaseManager()
    
    public weak var delegate: DatabaseManagerDelegate?
    
    private var fireStore: Firestore = {
        let db = Firestore.firestore()
        db.settings.isSSLEnabled = true
        return db
    }()
    
    public func create<T: Identifiable & FirebaseStorable>(storable:T) {
        let col = fireStore.collection(storable.collection.rawValue)
        let doc = col.document(storable.id)
        doc.setData(storable.convert()) { (error) in
            guard error == nil else {
                let fireBaseError = FirebaseError.createDocumentError(error!)
                self.delegate?.databaseManager(self, didReceiveError: fireBaseError)
                return
            }
            self.delegate?.databaseManager(self, didCreateDocument: doc.documentID)
        }
    }
    
    public func delete<T:Identifiable & FirebaseStorable>(storable:T){
        let ref = fireStore.collection(storable.collection.rawValue)
            .document(storable.id)
        ref.delete { (error) in
            if let error = error {
                let fireBaseError = FirebaseError.deleteDocumentError(error)
                self.delegate?.databaseManager(self, didReceiveError: fireBaseError)
            }
            self.delegate?.databaseManager(self, didDeleteDocument: true)
        }
    }
    
    public func update<T:Identifiable & FirebaseStorable, U>(storable:T,
                                                             newValues:[String:U]){
        let ref = fireStore.collection(storable.collection.rawValue)
            .document(storable.id) // making the user document id the same as the auth userId makes it easy to update the user doc
        ref.updateData(newValues) { (error) in
            guard error == nil else {
                let fireBaseError = FirebaseError.updateDocumentError(error!)
                self.delegate?.databaseManager(self, didReceiveError: fireBaseError)
                return
            }
            self.delegate?.databaseManager(self, didUpdateDocument: ref.documentID)
        }
    }
    
    public func fetch<T:Identifiable & FirebaseStorable>(storable:T){
        fireStore.collection(storable.collection.rawValue)
            .document(storable.id)
            .getDocument { (document, error) in
                if let error = error {
                    let fireBaseError = FirebaseError.fetchDocumentError(error)
                    self.delegate?.databaseManager(self, didReceiveError: fireBaseError)
                } else if let document = document, let data = document.data() {
                    let document = (id:document.documentID, data:data)
                    self.delegate?.databaseManager(self, didReceiveDocument: document)
                } else {
                    let fireBaseError = FirebaseError.noDocumentError("No Document with id: \(storable.id)")
                    self.delegate?.databaseManager(self, didReceiveError: fireBaseError)
                }
        }
    }
    
    public func fetchAll(collection:Collection){
        fireStore.collection(collection.rawValue)
            .getDocuments { (collection, error) in
                if let error = error {
                    let fireBaseError = FirebaseError.fetchDocumentError(error)
                    self.delegate?.databaseManager(self, didReceiveError: fireBaseError)
                } else if let collection = collection {
                    let documents = collection.documents.map { (id:$0.documentID, data:$0.data())}
                    self.delegate?.databaseManager(self, didReceiveDocuments: documents)
                }
        }
    }
    
    //    public let url = "gs://streamapp-87c97.appspot.com"
    
}
