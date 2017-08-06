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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true // 文字を非表示
    }
    
    //Returmキーで閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        NameTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func Login() {
        print("ログインボタンを押した")
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { user, error in
            if let error = error {
                print("サインインできません \(error)")
            }
            
            if let user = user {
                print("user : \(user.email!)でサインインできました")
                
                //PVPViewに画面遷移
                self.transitionToLogin()
            }
        })
    }
    
    @IBAction func pw_on_off() {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
            
        }else if passwordTextField.isSecureTextEntry == false {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    //pvp画面への遷移
    func transitionToLogin() {
        //self.performSegue(withIdentifier: "toLogin", sender: self)
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "topvp") as! pvpViewController
        self.present(nextView, animated: true, completion: nil)
    }
}
