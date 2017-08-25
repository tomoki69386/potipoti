//
//  RoomViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/08/19.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class RoomViewController: UIViewController{
    
    let userDefault = UserDefaults.standard
    var ref: DatabaseReference! //Firebase
    let user = Auth.auth().currentUser
    var num : Int! //どちらから始めるか決めるのに使う
    
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
    
    //ハズレかアタリか表示
    @IBOutlet var HanteiLabel: UILabel!
    
    //どちらの番か表示
    @IBOutlet var Playerlable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ロード画面の表示
        SVProgressHUD.show()
        
        //ボタンを無効化
        self.button0.isEnabled = false
        self.button1.isEnabled = false
        self.button2.isEnabled = false
        self.button3.isEnabled = false
        self.button4.isEnabled = false
        self.button5.isEnabled = false
        self.button6.isEnabled = false
        self.button7.isEnabled = false
        self.button9.isEnabled = false
        self.button10.isEnabled = false
        self.button11.isEnabled = false
        self.button12.isEnabled = false
        self.button13.isEnabled = false
        self.button14.isEnabled = false
        self.button15.isEnabled = false
        self.button16.isEnabled = false
        self.button17.isEnabled = false
        self.button18.isEnabled = false
        self.button19.isEnabled = false
        
        
        let RoomID = userDefault.integer(forKey: "ルームID")
        ref = Database.database().reference()
        
        //対戦者の選択待ち
        self.ref.child("rooms").child(String(RoomID)).child("messages").observe(.value, with: {(snapShots) in
            
            let battle = String(describing: snapShots.childSnapshot(forPath: "対戦").value!)
            print("対戦は...\(battle)")
            
            if battle == "しない" {
                //対戦をしない時の処理
                //ルームの削除
                self.ref.child("rooms").child(String(RoomID)).removeValue()
                print("ルームの削除")
                
                //相手のルームも削除
                let enemyID = self.userDefault.string(forKey: "enemyID")
                print("相手のIDは...\(enemyID)")
                
                self.ref.child("users").child(enemyID!).child("RoomID").removeValue()
                print("enemyのRoomIDを削除")
                
                //ロード画面の削除
                SVProgressHUD.dismiss()
                
                //対戦を拒否されたので画面を1つ戻る
                let alert = UIAlertController(
                    title: "拒否されました",
                    message: "対戦を拒否されたので新しく対戦者を選択して下さい",
                    preferredStyle: .alert)
                // アラートにボタンをつける
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                // アラート表示
                self.present(alert, animated: true, completion: nil)
                
                print("画面を戻る")
                
            }else if battle == "する" {
                //相手が入室した時の処理
                SVProgressHUD.showSuccess(withStatus: "対戦者入室")
                
                self.num = Int(arc4random_uniform(1))
                let enemyID = self.userDefault.string(forKey: "enemyID")
                
                //0なら自分からタップできる
                if self.num == 0 {
                    self.ref.child("rooms").child(String(RoomID)).child("battle").setValue(["Tap Player ID": self.user?.uid,])
                    
                    //1なら相手からタップできる
                }else if self.num == 1 {
                    self.ref.child("rooms").child(String(RoomID)).child("battle").setValue(["Tap Player ID": enemyID,])
                }
                
                //0.5秒の間待つ
                let when = DispatchTime.now() + 0.5
                
                DispatchQueue.main.asyncAfter(deadline: when) {
                    
                }
            }
        })
    }
    
    //ボタンを押したときの処理
    @IBAction func tap(sender: UIButton) {
        switch sender.tag {
        case 0:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 0])
        case 1:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 1])
        case 2:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 2])
        case 3:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 3])
        case 4:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 4])
        case 5:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 5])
        case 6:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 6])
        case 7:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 7])
        case 8:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 8])
        case 9:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 9])
        case 10:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 10])
        case 11:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 11])
        case 12:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 12])
        case 13:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 13])
        case 14:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 14])
        case 15:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 15])
        case 16:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 16])
        case 17:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 17])
        case 18:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 18])
        case 19:
            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").setValue(["Button": 19])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
