//
//  ViewController.swift
//  黒ひげ
//
//  Created by 築山朋紀 on 2017/04/08.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit

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
    
    var index: Int = 0
    var defaults: UserDefaults = UserDefaults.standard
    let ninzuuArrey: [String] = ["２人","３人","４人"]
    
    //追記
    let SCREEN_SIZE = UIScreen.main.bounds.size
    
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
        
        //以下追記
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //ここでUIKeyboardWillShowという名前の通知のイベントをオブザーバー登録をしている
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        //ここでUIKeyboardWillHideという名前の通知のイベントをオブザーバー登録をしている
        
    }
    
    @IBAction func up() {
        label.text = ninzuuArrey[index]
        
        index = index + 1
        
        //indexが２より大きくしない
        if index > 2 {
            index = 2
        }
        
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
        label.text = ninzuuArrey[index]
        
        index = index - 1
        
        //indexが０より小さくしない
        if index < 0 {
            index = 0
        }
        
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
            
        }else if label.text == ("３人") {
            //TextFieldに文字が入ってないと以下の処理をしない
            defaults.set(PlayertextField1.text, forKey: "Player1")
            defaults.set(PlayertextField2.text, forKey: "Player2")
            defaults.set(PlayertextField3.text, forKey: "Player3")
            
            //人数を記録
            defaults.set(3, forKey: "ninzuu")
            
        }else if label.text == ("２人") {
            //TextFieldに文字が入ってないと以下の処理をしない
            defaults.set(PlayertextField1.text, forKey: "Player1")
            defaults.set(PlayertextField2.text, forKey: "Player2")
            
            //人数を記録
            defaults.set(2, forKey: "ninzuu")
        }
        
        //画面遷移
        let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "Game" ) as! GameViewController
        self.present( targetViewController, animated: true, completion: nil)
        
    }
    
    //リターンでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        PlayertextField1.resignFirstResponder()
        PlayertextField2.resignFirstResponder()
        PlayertextField3.resignFirstResponder()
        PlayertextField4.resignFirstResponder()
        return true
    }
    
    //Topに戻る
    @IBAction func tophe() {
        dismiss(animated: true, completion: nil)
    }
    
    //キーボード以外をタップした時キーボードを下げる
    //正常に動いてない。けど問題ない
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //非表示にする。
        if(PlayertextField1.isFirstResponder){
            PlayertextField1.resignFirstResponder()
            
        }else if (PlayertextField2.isFirstResponder){
            PlayertextField2.resignFirstResponder()
            
        }else if (PlayertextField3.isFirstResponder){
            PlayertextField3.resignFirstResponder()
            
        }else if (PlayertextField4.isFirstResponder){
            PlayertextField4.resignFirstResponder()
        }
    }
    
    //以下追記
    
    //Viewをタップした時に起こる処理を描く関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //キーボードを閉じる処理
        view.endEditing(true)
    }
    
    //UIKeyboardWillShow通知を受けて、実行される関数
    func keyboardWillShow(_ notification: NSNotification){
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.height
        PlayertextField1.frame.origin.y = SCREEN_SIZE.height - keyboardHeight - PlayertextField1.frame.height
        PlayertextField2.frame.origin.y = SCREEN_SIZE.height - keyboardHeight - PlayertextField2.frame.height
        PlayertextField3.frame.origin.y = SCREEN_SIZE.height - keyboardHeight - PlayertextField3.frame.height
        PlayertextField4.frame.origin.y = SCREEN_SIZE.height - keyboardHeight - PlayertextField4.frame.height
    }
    
    //UIKeyboardWillShow通知を受けて、実行される関数
    func keyboardWillHide(_ notification: NSNotification){
        PlayertextField1.frame.origin.y = SCREEN_SIZE.height - PlayertextField1.frame.height
        PlayertextField2.frame.origin.y = SCREEN_SIZE.height - PlayertextField2.frame.height
        PlayertextField3.frame.origin.y = SCREEN_SIZE.height - PlayertextField3.frame.height
        PlayertextField4.frame.origin.y = SCREEN_SIZE.height - PlayertextField4.frame.height
    }
}
