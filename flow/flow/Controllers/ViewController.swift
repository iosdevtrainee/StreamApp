//
//  ViewController.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private lazy var sessionManager: SessionManager = {
       let sm = SessionManager()
        sm.accountDelegate = self
        return sm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func createUser(_ sender: UIButton) {
        guard let email = usernameTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty else {
                return
        }
        sessionManager.createUser(email: email, password: password)
    }
    
}

extension ViewController: AccountCreationDelegate {
    func sessionManager(_ sessionManager: SessionManager, didReceiveError error: FirebaseError) {
        print(error.localizedDescription)
    }
    
    func sessionManager(_ sessionManager: SessionManager, didCreateUser user: AuthUser) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard
            .instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        profileVC.user = user
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
