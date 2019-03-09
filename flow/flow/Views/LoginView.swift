//
//  LoginView.swift
//  flow
//
//  Created by iosdevrookie on 3/1/19.
//  Copyright © 2019 iosdevrookie. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    public lazy var emailTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "email"

        return tf
    }()
    
    public lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    public lazy var loginButton: UIButton = {
       let btn = UIButton()
       btn.setTitle("Login", for: .normal)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    private func commonInit(){
        
    }

}

extension LoginView {
    private func setupView(){
        
    }
    
    private func setConstraints(){
        
    }
}
