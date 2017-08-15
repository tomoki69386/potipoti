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
import FirebaseDatabase
import SVProgressHUD

class newViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordTextField2: UITextField!
    
    var emailRef:DatabaseReference! //Firebase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField2.delegate = self
        passwordTextField2.isSecureTextEntry = true //文字を非表示に
        passwordTextField.isSecureTextEntry  = true // 文字を非表示に
        
        //枠を黒くする
        NameTextField.layer.borderWidth = 2
        passwordTextField.layer.borderWidth = 2
        emailTextField.layer.borderWidth = 2
        passwordTextField2.layer.borderWidth = 2
        
        emailRef = Database.database().reference()
    }
    
    //Returmキーで閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        NameTextField.resignFirstResponder()
        passwordTextField2.resignFirstResponder()
        return true
    }
    
    //ユーザー作成
    @IBAction func new(_ sender: Any) {
        
        if let username = NameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text {
            if username.characters.isEmpty {
                SVProgressHUD.showError(withStatus: "Oops!")
                NameTextField.layer.borderColor = UIColor.red.cgColor
                return
            }
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
            NameTextField.layer.borderColor = UIColor.black.cgColor
            emailTextField.layer.borderColor = UIColor.black.cgColor
            passwordTextField.layer.borderColor = UIColor.black.cgColor
            
            SVProgressHUD.show()
            
            // ユーザー作成
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if let error = error {
                    print(error)
                    SVProgressHUD.showError(withStatus: "Error!")
                    return
                }
                // ユーザーネームを設定
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = username
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print(error)
                            SVProgressHUD.showError(withStatus: "Error!")
                            return
                        }
                        SVProgressHUD.showSuccess(withStatus: "Success!")
                        
                        let when = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            self.present((self.storyboard?.instantiateViewController(withIdentifier: "TabBarController"))!,
                                         animated: true,
                                         completion: nil)
                        }
                    }
                } else {
                    print("Error - User not found")
                }
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func fuga() {
        //いおりデータサンプル
        //DBRef.child("falseband/\(sendoutInt+1)/Vo").updateChildValues(["Name": vocalBandNameArray[sendoutInt]]
    }
    
    //PVPViewに画面遷移
    func transitionTopvp() {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
        self.present(nextView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
