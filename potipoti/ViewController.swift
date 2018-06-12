//
//  ViewController.swift
//  黒ひげ
//
//  Created by 築山朋紀 on 2017/04/08.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //trueならアラートを表示中、falseならアラートを表示していない
    var Existence: Bool = false
    var ref: DatabaseReference!
    let pickerVeiew = UIPickerView()
    
    var index: Int = 0
    let userDefaults = UserDefaults.standard
    let ninzuuArrey: [String] = ["２人","３人","４人"]
    var memberNameArrey: [String] = []
    
    let toBattleButton = UIButton()
    let textField = UITextField()
    let ninzuLabel = UILabel()
    let nameLabel = UILabel()
    let Player1TextField = UITextField()
    let Player2TextField = UITextField()
    let Player3TextField = UITextField()
    let Player4TextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        pickerVeiew.delegate = self
        Player1TextField.delegate = self
        Player2TextField.delegate = self
        Player3TextField.delegate = self
        Player4TextField.delegate = self
        
        pickerVeiew.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerVeiew.bounds.size.height)
        
        let vi = UIView(frame: pickerVeiew.bounds)
        vi.backgroundColor = UIColor.white
        vi.addSubview(pickerVeiew)
        
        textField.inputView = vi
        
        //PickerViewの上に表示する
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton   = UIBarButtonItem(title: "決定", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        
        //キーボードの上に表示する
        let keyboardBar = UIToolbar()
        keyboardBar.barStyle = UIBarStyle.default
        keyboardBar.isTranslucent = true
        keyboardBar.tintColor = UIColor.black
        
        let done = UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.done))
        
        keyboardBar.setItems([spaceButton, done], animated: false)
        keyboardBar.isUserInteractionEnabled = true
        keyboardBar.sizeToFit()
        Player1TextField.inputAccessoryView = keyboardBar
        Player2TextField.inputAccessoryView = keyboardBar
        Player3TextField.inputAccessoryView = keyboardBar
        Player4TextField.inputAccessoryView = keyboardBar
        
        //スクリーンサイズ
        let screenWidth: CGFloat = self.view.frame.width
        let screenHeight: CGFloat = self.view.frame.height
        
        //ボタンのサイズ
        let buttonSize = screenWidth / 4
        
        //位置
        toBattleButton.frame = CGRect(x: 0, y: screenHeight - buttonSize, width: screenWidth, height: buttonSize)
        textField.frame = CGRect(x: 15, y: buttonSize + 20, width: screenWidth - 30, height: 30)
        ninzuLabel.frame = CGRect(x: 15, y: buttonSize, width: screenWidth - 30, height: 15)
        nameLabel.frame = CGRect(x: 15, y: buttonSize + 65, width: screenWidth - 30, height: 15)
        Player1TextField.frame = CGRect(x: 15, y: buttonSize + 90, width: screenWidth - 30, height: 30)
        Player2TextField.frame = CGRect(x: 15, y: buttonSize + 130, width: screenWidth - 30, height: 30)
        Player3TextField.frame = CGRect(x: 15, y: buttonSize + 170, width: screenWidth - 30, height: 30)
        Player4TextField.frame = CGRect(x: 15, y: buttonSize + 210, width: screenWidth - 30, height: 30)
        
        //テキスト
        toBattleButton.setTitle("プレイ", for: UIControlState.normal)
        ninzuLabel.text = "人数選択"
        nameLabel.text = "プレイヤーの名前"
        textField.text = "２人"
        
        //最初は非表示にしておく
        Player3TextField.isHidden = true
        Player4TextField.isHidden = true
        
        //文字入力前に表示設定
        Player1TextField.placeholder = "名前を入力してください"
        Player2TextField.placeholder = "名前を入力してください"
        Player3TextField.placeholder = "名前を入力してください"
        Player4TextField.placeholder = "名前を入力してください"
        
        //自動校正
        Player1TextField.autocorrectionType = .no
        Player2TextField.autocorrectionType = .no
        Player3TextField.autocorrectionType = .no
        Player4TextField.autocorrectionType = .no
        
        //テキストを右寄せにする
        textField.textAlignment = NSTextAlignment.right
        Player1TextField.textAlignment = NSTextAlignment.right
        Player2TextField.textAlignment = NSTextAlignment.right
        Player3TextField.textAlignment = NSTextAlignment.right
        Player4TextField.textAlignment = NSTextAlignment.right
        
        //カラー
        toBattleButton.setTitleColor(UIColor.black, for: .normal)
        ninzuLabel.textColor = UIColor.black
        nameLabel.textColor = UIColor.black
        Player1TextField.textColor = UIColor.black
        Player2TextField.textColor = UIColor.black
        Player3TextField.textColor = UIColor.black
        Player4TextField.textColor = UIColor.black
        
        //フォントサイズ
        toBattleButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        ninzuLabel.font = UIFont.systemFont(ofSize: 14)
        textField.font = UIFont.systemFont(ofSize: 14)
        Player1TextField.font = UIFont.systemFont(ofSize: 14)
        Player2TextField.font = UIFont.systemFont(ofSize: 14)
        Player3TextField.font = UIFont.systemFont(ofSize: 14)
        Player4TextField.font = UIFont.systemFont(ofSize: 14)
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        
        //バックグラウンドカラー
        toBattleButton.backgroundColor = UIColor(hex: "FEF978")
        
        //枠丸にする
        textField.layer.cornerRadius = 10
        Player1TextField.layer.cornerRadius = 10
        Player2TextField.layer.cornerRadius = 10
        Player3TextField.layer.cornerRadius = 10
        Player4TextField.layer.cornerRadius = 10
        
        //枠のカラー
        textField.layer.borderColor = UIColor.black.cgColor
        Player1TextField.layer.borderColor = UIColor.black.cgColor
        Player2TextField.layer.borderColor = UIColor.black.cgColor
        Player3TextField.layer.borderColor = UIColor.black.cgColor
        Player4TextField.layer.borderColor = UIColor.black.cgColor
        
        //枠の幅
        textField.layer.borderWidth = 1.0
        Player1TextField.layer.borderWidth = 1.0
        Player2TextField.layer.borderWidth = 1.0
        Player3TextField.layer.borderWidth = 1.0
        Player4TextField.layer.borderWidth = 1.0
        
        //アクション
        toBattleButton.addTarget(self, action: #selector(ViewController.tap(sender:)), for: .touchUpInside)
        
        self.view.addSubview(toBattleButton)
        self.view.addSubview(textField)
        self.view.addSubview(ninzuLabel)
        self.view.addSubview(nameLabel)
        self.view.addSubview(Player1TextField)
        self.view.addSubview(Player2TextField)
        self.view.addSubview(Player3TextField)
        self.view.addSubview(Player4TextField)
        
        self.onlineBattle()
        
    }
    
    // 列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ninzuuArrey.count
    }
    
    //表示する内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ninzuuArrey[row]
    }
    
    //選択されたときの挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = ninzuuArrey[row]
        
        switch ninzuuArrey[row] {
        case "２人":
            Player3TextField.isHidden = true
            Player4TextField.isHidden = true
        case "３人":
            Player3TextField.isHidden = false
            Player4TextField.isHidden = true
        case "４人":
            Player3TextField.isHidden = false
            Player4TextField.isHidden = false
        default:
            print("error")
        }
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
    
    @objc func done() {
        view.endEditing(true)
    }
    
    @objc func tap(sender: UIButton) {
        
        userDefaults.removeObject(forKey: "memberName")
    
        switch textField.text {
        case "２人":
            if Player1TextField.text == "" || Player2TextField.text == "" {
                
                //エラーと表示する
                SVProgressHUD.showError(withStatus: "Error")
                
                if Player1TextField.text == "" {
                    Player1TextField.layer.borderColor = UIColor.red.cgColor
                }
                
                if Player2TextField.text == "" {
                    Player2TextField.layer.borderColor = UIColor.red.cgColor
                }
                
            }else {
                memberNameArrey.append(Player1TextField.text ?? "")
                memberNameArrey.append(Player2TextField.text ?? "")
                
                userDefaults.set(memberNameArrey, forKey: "memberName")
                //対戦画面に飛ぶ
                let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "GameViewController" ) as! GameViewController
                self.present( targetViewController, animated: true, completion: nil)
            }
        case "３人":
            if Player1TextField.text == "" || Player2TextField.text == "" || Player3TextField.text == "" {
                
                //エラーと表示する
                SVProgressHUD.showError(withStatus: "Error")
                
                if Player1TextField.text == "" {
                    Player1TextField.layer.borderColor = UIColor.red.cgColor
                }
                
                if Player2TextField.text == "" {
                    Player2TextField.layer.borderColor = UIColor.red.cgColor
                }
                
                if Player3TextField.text == "" {
                    Player3TextField.layer.borderColor = UIColor.red.cgColor
                }
                
            }else {
                memberNameArrey.append(Player1TextField.text ?? "")
                memberNameArrey.append(Player2TextField.text ?? "")
                memberNameArrey.append(Player3TextField.text ?? "")
                
                userDefaults.set(memberNameArrey, forKey: "memberName")
                //対戦画面に飛ぶ
                let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "GameViewController" ) as! GameViewController
                self.present( targetViewController, animated: true, completion: nil)
            }
        case "４人":
            if Player1TextField.text == "" || Player2TextField.text == "" || Player3TextField.text == "" || Player4TextField.text == ""{
                
                //エラーと表示する
                SVProgressHUD.showError(withStatus: "Error")
                
                if Player1TextField.text == "" {
                    Player1TextField.layer.borderColor = UIColor.red.cgColor
                }
                
                if Player2TextField.text == "" {
                    Player2TextField.layer.borderColor = UIColor.red.cgColor
                }
                
                if Player3TextField.text == "" {
                    Player3TextField.layer.borderColor = UIColor.red.cgColor
                }
                
                if Player4TextField.text == "" {
                    Player4TextField.layer.borderColor = UIColor.red.cgColor
                }
                
            }else {
                memberNameArrey.append(Player1TextField.text ?? "")
                memberNameArrey.append(Player2TextField.text ?? "")
                memberNameArrey.append(Player3TextField.text ?? "")
                memberNameArrey.append(Player4TextField.text ?? "")
                
                userDefaults.set(memberNameArrey, forKey: "memberName")
                //対戦画面に飛ぶ
                let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "GameViewController" ) as! GameViewController
                self.present( targetViewController, animated: true, completion: nil)
            }
        default:
            print("error")
        }
    }
    
    //textFieldの編集中に呼び出す
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text == "２人" {
            if Player1TextField.text != "" {
                Player1TextField.layer.borderColor = UIColor.black.cgColor
            }
            if Player2TextField.text != "" {
                Player2TextField.layer.borderColor = UIColor.black.cgColor
            }
        }else if textField.text == "３人" {
            if Player1TextField.text != "" {
                Player1TextField.layer.borderColor = UIColor.black.cgColor
            }
            if Player2TextField.text != "" {
                Player2TextField.layer.borderColor = UIColor.black.cgColor
            }
            if Player3TextField.text != "" {
                Player3TextField.layer.borderColor = UIColor.black.cgColor
            }
        }else {
            if Player1TextField.text != "" {
                Player1TextField.layer.borderColor = UIColor.black.cgColor
            }
            if Player2TextField.text != "" {
                Player2TextField.layer.borderColor = UIColor.black.cgColor
            }
            if Player3TextField.text != "" {
                Player3TextField.layer.borderColor = UIColor.black.cgColor
            }
            if Player4TextField.text != "" {
                Player4TextField.layer.borderColor = UIColor.black.cgColor
            }
        }
        
        return true
    }
    
    func onlineBattle() {
        ref = Database.database().reference()
        
        if let _ = Auth.auth().currentUser {
            //ログイン中
            let user = Auth.auth().currentUser
            ref.child("users").child((user?.uid)!).observe(.value, with: {(snapShots) in
                
                let RoomID = String(describing: snapShots.childSnapshot(forPath: "RoomID").value!)
                
                if RoomID != "<null>" {
                    //nullじゃない時の処理
                    print("RoomIDは...\(RoomID)")
                    //対戦の挑戦状が届いたことを画面にアラートで表示
                    let Alert = UIAlertController(title: "対戦しますか？",message: "対戦の挑戦状が届きました、通信対戦をしますか？", preferredStyle: UIAlertControllerStyle.alert)
                    
                    //アラートを表示したのでExistenceをtrueに変える
                    self.Existence = true
                    
                    let battle = UIAlertAction(title: "承諾", style:UIAlertActionStyle.default){
                        (action: UIAlertAction) in
                        // 以下はボタンがクリックされた時の処理
                        //通信対戦画面に画面遷移
                        print("承諾をタップした")
                        
                        //アラートのボタンを押したのでExistenceをfalseに変える
                        self.Existence = false
                        
                        //自分のデータのinRoomに対戦中であることを書く
                        self.ref.child("users").child((user?.uid)!).updateChildValues(["inRoom": "true"])
                        
                        //EnemyRoomViewに画面遷移
                        let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "MemberViewController" ) as! MemberViewController
                        self.present( targetViewController, animated: true, completion: nil)
                        
                        //ルームに入ったことをのデータを追加
                        self.ref.child("rooms").child(RoomID).child("messages").updateChildValues(["対戦": "する"])
                    }
                    
                    let cancel = UIAlertAction(title: "拒否", style:UIAlertActionStyle.cancel){
                        (action: UIAlertAction) in
                        // 以下はボタンがクリックされた時の処理
                        //拒否したことを伝える
                        print("拒否をタップした")
                        
                        //アラートのボタンを押したのでExistenceをfalseに変える
                        self.Existence = false
                        
                        //拒否したことを伝える
                        self.ref.child("rooms").child(RoomID).child("messages").updateChildValues(["対戦": "しない"])
                    }
                    
                    //部品をアラートコントローラーに追加していく
                    Alert.addAction(battle)//battleを追加
                    Alert.addAction(cancel)//cancelを追加
                    
                    //アラートを表示
                    self.present(Alert,animated: true, completion: nil)
                    
                    //アラートを表示してから13秒経てばアラートを閉じる
                    let when = DispatchTime.now() + 13
                    //アラートを閉じる
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        Alert.dismiss(animated: true, completion: nil)
                    }
                }
            })
            return
        }else {
            //ログインしてない
            return
        }
    }
    
}
