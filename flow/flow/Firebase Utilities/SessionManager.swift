//
//  SessionManager.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol SignInDelegate: AnyObject {
    func sessionManager(_ sessionManager:SessionManager, didReceiveError error:FirebaseError)
    func sessionManager(_ sessionManager:SessionManager, didSignInUser user:AuthUser)
}

protocol AccountCreationDelegate: AnyObject {
    func sessionManager(_ sessionManager:SessionManager, didReceiveError error:FirebaseError)
    func sessionManager(_ sessionManager:SessionManager, didCreateUser user:AuthUser)
}

protocol AccountRemovalDelegate: AnyObject {
    func sessionManager(_ sessionManager:SessionManager, didReceiveError:FirebaseError)
    func sessionManager(_ sessionManager:SessionManager, didDeleteUser success:Bool)
}

protocol SignOutDelegate: AnyObject {
    func sessionManager(_ sessionManager:SessionManager, didReceiveError error:FirebaseError)
    func sessionManager(_ sessionManager:SessionManager, didSignOutUser success:Bool)
}

final class SessionManager {
    public weak var accountDelegate: AccountCreationDelegate?
    public weak var signInDelegate: SignInDelegate?
    public weak var signOutDelegate: SignOutDelegate?
    private var user: User?
    
    public var currentAuthUser: AuthUser? {
        guard let user = Auth.auth().currentUser,
            let email = user.email else {
            return nil
        }
        return AuthUser(id:user.uid, email:email)
    }
    
    public var currentUser: User? {
        return user
    }
    
    public func createUser(email:String, password:String){
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            if let error = error {
                let fireBaseError = FirebaseError.accountCreationError(error)
                self.accountDelegate?.sessionManager(self, didReceiveError: fireBaseError)
            } else if let authResult = authData, let email = authResult.user.email {
                let user = authResult.user
                let authUser = AuthUser(id:user.uid, email:email)
                self.accountDelegate?.sessionManager(self, didCreateUser: authUser)
            }
        }
    }
    
    public func signOut(user:AuthUser) {
        do {
            try Auth.auth().signOut()
            signOutDelegate?.sessionManager(self, didSignOutUser: true)
        } catch {
            signOutDelegate?.sessionManager(self, didReceiveError: FirebaseError.signOutError(error))
        }
    }
}
