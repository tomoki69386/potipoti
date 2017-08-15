//
//  LoginViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/07/22.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true // 文字を非表示
        
        emailTextField.layer.borderWidth = 2
        passwordTextField.layer.borderWidth = 2
    }
    
    //Returmキーで閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func pushSigninButton(_ sender: Any) {
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            if email.characters.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                emailTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
            if password.characters.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
            emailTextField.layer.borderColor = UIColor.black.cgColor
            passwordTextField.layer.borderColor = UIColor.black.cgColor
            
            SVProgressHUD.show()
            
            // ログイン
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                if let error = error {
                    print(error)
                    SVProgressHUD.showError(withStatus: "Error!")
                    return
                } else {
                    SVProgressHUD.showSuccess(withStatus: "Success!")
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.present((self.storyboard?.instantiateViewController(withIdentifier: "TabBarController"))!,
                                     animated: true,
                                     completion: nil)
                    }
                }
            }
        }
    }
}
