//
//  MemberViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/08/29.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class MemberViewController: UIViewController {
    
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
    
    var ref: DatabaseReference! //Firebase
    let user = Auth.auth().currentUser
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.showSuccess(withStatus: "対戦者入室")
        
        //Firebase
        ref = Database.database().reference()
        
        //RoomIDの取得
        self.ref.child("users").child((user?.uid)!).observe(.value, with: {(snapShots) in
            
            //RoomIDの宣言
            let RoomID = String(describing: snapShots.childSnapshot(forPath: "RoomID").value!)
            
            self.userDefault.set(RoomID, forKey: "RoomID")
            
            print(RoomID)
            
            self.ref.child("rooms").child(RoomID).child("messages").observe(.value, with: {(snapShots) in
                
                //ハズレのボタンを取得
                let LosingButton = String(describing: snapShots.childSnapshot(forPath: "ハズレボタン").value!)
                
                //最初にボタンを押せるユーザーを取得
                let TP = String(describing: snapShots.childSnapshot(forPath: "TP").value!)
                
                print("ハズレのボタンは...\(LosingButton)")
                print("最初にボタンを押せるのは...\(TP)")
                
                if TP == "0" {
                    //hostが押せる時の処理
                    print("ボタンを無効化")
                    self.button_Disabled()
                }else if TP == "1" {
                    //memberが押せる時の処理
                    print("ボタン有効化")
                    self.button_Effectiveness()
                }
            })
        })
    }
    
    //ボタンを押した時の処理
    @IBAction func tap(sender: UIButton) {
        
        let roomID = userDefault.string(forKey: "RoomID")
        print("ルームIDは...\(roomID)")
        
        switch sender.tag {
        case 0:
            let hoge = ["button": "0"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 1:
            let hoge = ["button": "1"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 2:
            let hoge = ["button": "2"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 3:
            let hoge = ["button": "3"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 4:
            let hoge = ["button": "4"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 5:
            let hoge = ["button": "5"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 6:
            let hoge = ["button": "6"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 7:
            let hoge = ["button": "7"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 8:
            let hoge = ["button": "8"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 9:
            let hoge = ["button": "9"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 10:
            let hoge = ["button": "10"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 11:
            let hoge = ["button": "11"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 12:
            let hoge = ["button": "12"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 13:
            let hoge = ["button": "13"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 14:
            let hoge = ["button": "14"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 15:
            let hoge = ["button": "15"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 16:
            let hoge = ["button": "16"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 17:
            let hoge = ["button": "17"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 18:
            let hoge = ["button": "18"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        case 19:
            let hoge = ["button": "19"]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").setValue(hoge)
        default:
            print("当てはまらない")
        }
        self.ref.child("rooms").child(roomID!).child("messages").setValue(["TP": 0])
    }
    
    //ボタン有効化する処理
    func button_Effectiveness() {
        button0.isEnabled = true
        button1.isEnabled = true
        button2.isEnabled = true
        button3.isEnabled = true
        button4.isEnabled = true
        button5.isEnabled = true
        button6.isEnabled = true
        button7.isEnabled = true
        button9.isEnabled = true
        button10.isEnabled = true
        button11.isEnabled = true
        button12.isEnabled = true
        button13.isEnabled = true
        button14.isEnabled = true
        button15.isEnabled = true
        button16.isEnabled = true
        button17.isEnabled = true
        button18.isEnabled = true
        button19.isEnabled = true
    }
    
    //ボタン無効化する処理
    func button_Disabled() {
        button0.isEnabled = false
        button1.isEnabled = false
        button2.isEnabled = false
        button3.isEnabled = false
        button4.isEnabled = false
        button5.isEnabled = false
        button6.isEnabled = false
        button7.isEnabled = false
        button9.isEnabled = false
        button10.isEnabled = false
        button11.isEnabled = false
        button12.isEnabled = false
        button13.isEnabled = false
        button14.isEnabled = false
        button15.isEnabled = false
        button16.isEnabled = false
        button17.isEnabled = false
        button18.isEnabled = false
        button19.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
