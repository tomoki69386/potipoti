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
                //対戦するの時の処理
                //相手が入室した時の処理でもある
                SVProgressHUD.showSuccess(withStatus: "対戦者入室")
                
                //2秒の間待つ
                let when = DispatchTime.now() + 2
                
                DispatchQueue.main.asyncAfter(deadline: when) {
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
