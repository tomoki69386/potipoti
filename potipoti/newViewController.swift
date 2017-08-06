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
    @IBOutlet var passwordTextField2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField2.delegate = self
        passwordTextField2.isSecureTextEntry = true //文字を非表示に
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
        let pw2 = passwordTextField2.text
        
        if pw == pw2 { //パスワードが一致したらユーザーを作る処理に移る
            
            Auth.auth().createUser(withEmail: email!, password: pw!, completion: { (user:User?, error:NSError?) in
                if let error = error {
                    print("Creating the user failed! \(error)")
                    return
                }
                
                if let user = user {
                    print("user : \(String(describing: user.email)) has been created successfully.")
                    self.transitionTopvp()
                }
            } as? AuthResultCallback)
        }else { //パスワードが一致しなかったらここを通る
            print("パスワードが一致しません")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func transitionTopvp() {
        //self.performSegue(withIdentifier: "toLogin", sender: self)
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "topvp") as! pvpViewController
        self.present(nextView, animated: true, completion: nil)
    }
}
