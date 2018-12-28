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
    
//    @IBOutlet var passwordTextField: UITextField!
//    @IBOutlet var emailTextField: UITextField!
    var ref: DatabaseReference!
    
    let passwordTextField = UITextField()
    let emailTextField = UITextField()
    let loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true // 文字を非表示
        
        emailTextField.layer.borderWidth = 2
        passwordTextField.layer.borderWidth = 2
        
        
        //キーボードのフォーカスをあわせる
        emailTextField.becomeFirstResponder()
    }
    
    func setUI() {
        //スクリーンサイズ
        let screenWidth: CGFloat = self.view.frame.width
        let screenHeight: CGFloat = self.view.frame.height
        let buttonSize = screenWidth / 4
        
        //位置を設定する
        loginButton.frame = CGRect(x: 0, y: screenHeight - buttonSize, width: screenWidth, height: buttonSize)
        
        //表示するテキストを設定する
        loginButton.setTitle("ログイン", for: .normal)
        
        //テキストのカラーを設定
        loginButton.setTitleColor(UIColor(hex: "000000"), for: .normal)
        
        //背景のカラーを設定
        loginButton.backgroundColor = UIColor(hex: "FEF978")
        
        //フォントのサイズを設定する
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        //Buttonにアクションを与える
        loginButton.addTarget(self, action: #selector(LoginViewController.signinButton(sender:)), for: .touchUpInside)
        
        //Viewに追加
        self.view.addSubview(loginButton)
    
    }
    
    @objc func signinButton(sender: UIButton) {
        
    }
    
    //Returmキーで閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == (emailTextField) {
            //キーボードのフォーカスをあわせる
            passwordTextField.becomeFirstResponder()
        }else {
            //キーボードを閉じる
            passwordTextField.resignFirstResponder()
        }
        
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
                    SVProgressHUD.showError(withStatus: "エラー!")
                    return
                } else {
                    //ログインしたデータを送る
                    let user = Auth.auth().currentUser
                    self.ref = Database.database().reference()
                    //オンライン中であることを知らせる
                    self.ref.child("users").child(user!.uid).updateChildValues(["App":1])
                    
                    SVProgressHUD.showSuccess(withStatus: "ログイン出来ました！")

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
