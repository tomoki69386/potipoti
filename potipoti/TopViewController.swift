//
//  TopViewController.swift
//  黒ひげ
//
//  Created by 築山朋紀 on 2017/04/11.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TopViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button1.layer.cornerRadius = 30 //ボタンを丸める
        button2.layer.cornerRadius = 30
        button3.layer.cornerRadius = 30
        let user = Auth.auth().currentUser
        
        ref = Database.database().reference()
        //変更があれば処理する
        ref.child("users").child((user?.uid)!).observe(.value, with: {(snapShots) in
            
            let RoomID = String(describing: snapShots.childSnapshot(forPath: "RoomID").value!)
            print("RoomIDは...\(RoomID)")
            
            if RoomID != "<null>" {
                //nullじゃない時の処理
                //対戦の挑戦状が届いたことを画面にアラートで表示
                let Alert = UIAlertController(title: "対戦しますか？",message: "対戦の挑戦状が届きました、通信対戦をしますか？", preferredStyle: UIAlertControllerStyle.alert)
                
                let battle = UIAlertAction(title: "承諾", style:UIAlertActionStyle.default){
                    (action: UIAlertAction) in
                    // 以下はボタンがクリックされた時の処理
                    //通信対戦画面に画面遷移
                    print("承諾をタップした")
                    
                    //ルームに入ったことをのデータを追加
                    self.ref.child("rooms").child(RoomID).child("messages").updateChildValues(["対戦": "する"])
                    
                    //自分のデータのinRoomに対戦中であることを書く
                    self.ref.child("users").child((user?.uid)!).updateChildValues(["inRoom": "true"])
                    
                    //EnemyRoomViewに画面遷移
                    let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "MemberViewController" ) as! MemberViewController
                    self.present( targetViewController, animated: true, completion: nil)
                }
                
                let cancel = UIAlertAction(title: "拒否", style:UIAlertActionStyle.cancel){
                    (action: UIAlertAction) in
                    // 以下はボタンがクリックされた時の処理
                    //拒否したことを伝える
                    print("拒否をタップした")
                    
                    //拒否したことを伝える
                    self.ref.child("rooms").child(RoomID).child("messages").updateChildValues(["対戦": "しない"])
                }
                
                //部品をアラートコントローラーに追加していく
                Alert.addAction(battle)//battleを追加
                Alert.addAction(cancel)//cancelを追加
                
                //アラートを表示
                self.present(Alert,animated: true, completion: nil)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
