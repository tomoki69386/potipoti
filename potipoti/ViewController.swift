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

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var PlayerLabel1: UILabel!
    @IBOutlet var PlayerLabel2: UILabel!
    @IBOutlet var PlayerLabel3: UILabel!
    @IBOutlet var PlayerLabel4: UILabel!
    @IBOutlet var PlayertextField1: UITextField!
    @IBOutlet var PlayertextField2: UITextField!
    @IBOutlet var PlayertextField3: UITextField!
    @IBOutlet var PlayertextField4: UITextField!
    @IBOutlet var label: UILabel!
    //trueならアラートを表示中、falseならアラートを表示していない
    var Existence: Bool = false
    var ref: DatabaseReference!
    
    var index: Int = 0
    var defaults: UserDefaults = UserDefaults.standard
    let ninzuuArrey: [String] = ["２人","３人","４人"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayertextField1.delegate = self
        PlayertextField2.delegate = self
        PlayertextField3.delegate = self
        PlayertextField4.delegate = self
        
        //画面を開いたときは2人だから、3と4を非表示にしておく
        PlayertextField4.isHidden = true
        PlayertextField3.isHidden = true
        PlayerLabel4.isHidden = true
        PlayerLabel3.isHidden = true
        
        //ボタンを丸める
        button1.layer.cornerRadius = 30
        
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
    
    @IBAction func up() {
        index += 1
        
        //indexが２より大きくしない
        if index >= 2 {
            index = 2
        }
        label.text = ninzuuArrey[index]
        
        if label.text == ("４人") { //４人
            PlayertextField4.isHidden = false
            PlayertextField3.isHidden = false
            PlayerLabel4.isHidden = false
            PlayerLabel3.isHidden = false
            
        }else if label.text == ("３人") { //３人
            PlayertextField4.isHidden = true
            PlayertextField3.isHidden = false
            PlayerLabel4.isHidden = true
            PlayerLabel3.isHidden = false
            
        }else if label.text == ("２人") { //２人
            PlayertextField4.isHidden = true
            PlayertextField3.isHidden = true
            PlayerLabel4.isHidden = true
            PlayerLabel3.isHidden = true
            
        }
        
    }
    
    @IBAction func down() {
        index -= 1
        
        //indexが０より小さくしない
        if index <= 0 {
            index = 0
        }
        label.text = ninzuuArrey[index]
        
        if label.text == ("４人") { //４人
            PlayertextField4.isHidden = false
            PlayertextField3.isHidden = false
            PlayerLabel4.isHidden = false
            PlayerLabel3.isHidden = false
            
        }else if label.text == ("３人") { //３人
            PlayertextField4.isHidden = true
            PlayertextField3.isHidden = false
            PlayerLabel4.isHidden = true
            PlayerLabel3.isHidden = false
            
        }else if label.text == ("２人") { //２人
            PlayertextField4.isHidden = true
            PlayertextField3.isHidden = true
            PlayerLabel4.isHidden = true
            PlayerLabel3.isHidden = true
        }
    }
    
    //ゲームスタートButton
    @IBAction func Play() {
        if label.text == ("４人") {
            //TextFieldに文字が入ってないと以下の処理をしない
            guard (PlayerLabel1.text != nil) else { return }
            guard (PlayerLabel2.text != nil) else { return }
            guard (PlayerLabel3.text != nil) else { return }
            guard (PlayerLabel4.text != nil) else { return }
            
            defaults.set(PlayertextField1.text, forKey: "Player1")
            defaults.set(PlayertextField2.text, forKey: "Player2")
            defaults.set(PlayertextField3.text, forKey: "Player3")
            defaults.set(PlayertextField4.text, forKey: "Player4")
            
            //人数を記録
            defaults.set(4, forKey: "ninzuu")
            
            //画面遷移
            let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "Game" ) as! GameViewController
            self.present( targetViewController, animated: true, completion: nil)
            
        }else if label.text == ("３人") {
            //TextFieldに文字が入ってないと以下の処理をしない
            guard (PlayerLabel1.text != nil) else { return }
            guard (PlayerLabel2.text != nil) else { return }
            guard (PlayerLabel3.text != nil) else { return }
            
            defaults.set(PlayertextField1.text, forKey: "Player1")
            defaults.set(PlayertextField2.text, forKey: "Player2")
            defaults.set(PlayertextField3.text, forKey: "Player3")
            
            //人数を記録
            defaults.set(3, forKey: "ninzuu")
            
            //画面遷移
            let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "Game" ) as! GameViewController
            self.present( targetViewController, animated: true, completion: nil)
            
        }else if label.text == ("２人") {
            //TextFieldに文字が入ってないと以下の処理をしない
            guard (PlayerLabel1.text != nil) else { return }
            guard (PlayerLabel2.text != nil) else { return }
            
            defaults.set(PlayertextField1.text, forKey: "Player1")
            defaults.set(PlayertextField2.text, forKey: "Player2")
            
            //人数を記録
            defaults.set(2, forKey: "ninzuu")
            
            //画面遷移
            let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "Game" ) as! GameViewController
            self.present( targetViewController, animated: true, completion: nil)
        }
    }
    
    //Enterでフォーカスを変えるかキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == PlayertextField1 {
            PlayertextField2.becomeFirstResponder()
        }else if textField == PlayertextField2 {
            PlayertextField3.becomeFirstResponder()
        }else if textField == PlayertextField3 {
            PlayertextField4.becomeFirstResponder()
        }else if textField == PlayertextField4 {
            PlayertextField4.resignFirstResponder()
        }
        return true
    }
    
    //Topに戻る
    @IBAction func tophe() {
        dismiss(animated: true, completion: nil)
    }
    
    //Viewをタップした時に起こる処理を描く関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //キーボードを閉じる処理
        view.endEditing(true)
    }
    
}
