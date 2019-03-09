//
//  ProfileViewController.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var allDocuments: UITextView!
    @IBOutlet weak var welcomeLabel: UILabel!
    public var user:AuthUser?
    @IBOutlet weak var usernameTextField: UITextField!
    convenience init(user:AuthUser){
        self.init()
        self.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let aUser = user {
            welcomeLabel.text = "Welcome user with email \(aUser.email)"
        }
        DatabaseManager.shared.delegate = self
    }
    @IBAction func makeDocument(_ sender: UIButton) {
        
    }
    @IBAction func updateDocument(_ sender: UIButton) {
        DatabaseManager.shared.fetchAll(collection: .user)
    }
    
}

extension ProfileViewController: DatabaseManagerDelegate {
    func databaseManager(_ databaseManager: DatabaseManager, didReceiveError error: FirebaseError) {
        print(error.localizedDescription)
    }
    func databaseManager(_ databaseManager: DatabaseManager, willCreateDocument id: DocumentID) {
        print("Created User")
        user?.id = id
    }
    func databaseManager(_ databaseManager: DatabaseManager, didUpdateDocument id: DocumentID) {
        print("Updated Document")
    }
    func databaseManager(_ databaseManager: DatabaseManager, didReceiveDocuments documents: [Document]) {
        allDocuments.text = documents.map { $0.data.description }.joined()
    }
}
