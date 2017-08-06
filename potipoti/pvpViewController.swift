//
//  pvpViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/07/17.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class pvpViewController: UIViewController {
    
    var defaults: UserDefaults = UserDefaults.standard //要らない
    var number: Int = 0 //乱数用
    var count: Int = 19 //何回目か
    var j: Int = 0 //あたりかハズレを調べる変数
    var databaseRef:DatabaseReference! //Firebase
    
    @IBOutlet var label: UILabel! //ハズレかアタリか表示
    
    //使うボタンたち
    @IBOutlet var button0: UIButton!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    @IBOutlet var button10: UIButton!
    @IBOutlet var button11: UIButton!
    @IBOutlet var button12: UIButton!
    @IBOutlet var button13: UIButton!
    @IBOutlet var button14: UIButton!
    @IBOutlet var button15: UIButton!
    @IBOutlet var button16: UIButton!
    @IBOutlet var button17: UIButton!
    @IBOutlet var button18: UIButton!
    @IBOutlet var button19: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        //データの読み込み
        databaseRef.queryLimited(toLast: 100).observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let firebaseDic = snapshot.value as? [String: AnyObject] // unwrap it since its an optional
            {
                let fuga = firebaseDic["number"] as? String
                
                if fuga == String(0) {
                    if self.j == 0 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button0.isHidden = true
                    self.owari()
                    
                }else if fuga == String(1) {
                    if self.j == 1 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button1.isHidden = true
                    self.owari()
                    
                }else if fuga == String(2) {
                    if self.j == 2 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button2.isHidden = true
                    self.owari()
                    
                }else if fuga == String(3) {
                    if self.j == 3 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button3.isHidden = true
                    self.owari()
                    
                }else if fuga == String(4) {
                    if self.j == 4 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button4.isHidden = true
                    self.owari()
                    
                }else if fuga == String(5) {
                    if self.j == 5 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button5.isHidden = true
                    self.owari()
                    
                }else if fuga == String(6) {
                    if self.j == 6 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button6.isHidden = true
                    self.owari()
                    
                }else if fuga == String(7) {
                    if self.j == 7 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button7.isHidden = true
                    self.owari()
                    
                }else if fuga == String(8) {
                    if self.j == 8 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button8.isHidden = true
                    self.owari()
                    
                }else if fuga == String(9) {
                    if self.j == 9 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button9.isHidden = true
                    self.owari()
                    
                }else if fuga == String(10) {
                    if self.j == 10 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button10.isHidden = true
                    self.owari()
                    
                }else if fuga == String(11) {
                    if self.j == 11 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button11.isHidden = true
                    self.owari()
                    
                }else if fuga == String(12) {
                    if self.j == 12 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button12.isHidden = true
                    self.owari()
                    
                }else if fuga == String(13) {
                    if self.j == 13 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button13.isHidden = true
                    self.owari()
                    
                }else if fuga == String(14) {
                    if self.j == 14 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button14.isHidden = true
                    self.owari()
                    
                }else if fuga == String(15) {
                    if self.j == 15 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button15.isHidden = true
                    self.owari()
                    
                }else if fuga == String(16) {
                    if self.j == 16 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button16.isHidden = true
                    self.owari()
                    
                }else if fuga == String(17) {
                    if self.j == 17 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button17.isHidden = true
                    self.owari()
                    
                }else if fuga == String(18) {
                    if self.j == 18 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button18.isHidden = true
                    self.owari()
                    
                }else if fuga == String(19) {
                    if self.j == 19 {
                        self.hazure()
                    }else {
                        self.atari()
                    }
                    self.button19.isHidden = true
                    self.owari()
                }
            }
        }
        )
        //一旦ハズレを0にしておく
        j = 0
    }
    
    //ボタンを押したときの
    @IBAction func onClick(sender:UIButton){
        switch sender.tag {
        case 0:
            let messageDate = ["number" : "0"]
            databaseRef.childByAutoId().setValue(messageDate) 
        case 1:
            let messageDate = ["number" : "1"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 2:
            let messageDate = ["number" : "2"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 3:
            let messageDate = ["number" : "3"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 4:
            let messageDate = ["number" : "4"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 5:
            let messageDate = ["number" : "5"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 6:
            let messageDate = ["number" : "6"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 7:
            let messageDate = ["number" : "7"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 8:
            let messageDate = ["number" : "8"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 9:
            let messageDate = ["number" : "9"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 10:
            let messageDate = ["number" : "10"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 11:
            let messageDate = ["number" : "11"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 12:
            let messageDate = ["number" : "12"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 13:
            let messageDate = ["number" : "13"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 14:
            let messageDate = ["number" : "14"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 15:
            let messageDate = ["number" : "15"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 16:
            let messageDate = ["number" : "16"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 17:
            let messageDate = ["number" : "17"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 18:
            let messageDate = ["number" : "18"]
            databaseRef.childByAutoId().setValue(messageDate)
        case 19:
            let messageDate = ["number" : "19"]
            databaseRef.childByAutoId().setValue(messageDate)
        default:
            print("当てはまらない")
        }
    }

    func hazure() {
        // アラートを作成
        let alert = UIAlertController(
            title: "負けました",
            message: "終了",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)
        }))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func atari() {
        label.text = ("セーフ") //Labelにセーフ
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { //1.5秒後にLabelを消す
            self.label.text = ("")
        }
    }
    
    func owari() {
        count -= 1 //残りのボタンが何個か数える
        print("残りのボタンは...\(count)個")
        
        if count == 0 { //残りのボタンが1つになったらアラートを出す(勝ち)
            print("ボタンが無くなりました")
            // アラートを作成
            let alert = UIAlertController(
                title: "勝ちました",
                message: "終了",
                preferredStyle: .alert)
            
            // アラートにボタンをつける
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)
            }))
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
