//
//  newViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/07/28.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class newViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true // 文字を非表示に

        // Do any additional setup after loading the view.
    }
    
    //Returmキーで閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        NameTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func hoge() {
        let email = emailTextField.text
        let pw = passwordTextField.text
        
        Auth.auth().createUser(withEmail: email!, password: pw!, completion: { user, error in
            if let error = error {
                print("ユーザーを作れませんでした \(error)")
                return
            }
            
            if let user = user {
                print("user : \(user.email!)のユーザーを作成しました")
                self.transitionToView()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func transitionToView()  {
        self.performSegue(withIdentifier: "topvp", sender: self)
    }
}
