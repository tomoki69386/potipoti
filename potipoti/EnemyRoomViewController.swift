//
//
////
////  EnemyRoomViewController.swift
////  potipoti
////
////  Created by 築山朋紀 on 2017/08/25.
////  Copyright © 2017年 築山朋紀. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseDatabase
//import FirebaseAuth
//import SVProgressHUD
//
//class EnemyRoomViewController: UIViewController {
//    
//    let userDefault = UserDefaults.standard
//    var ref: DatabaseReference! //Firebase
//    let user = Auth.auth().currentUser
//    var MemberName: String!
//    var memberID: String!
//    var hazure : String!
//    
//    //使うボタンたち
//    @IBOutlet var button0: UIButton!
//    @IBOutlet var button1: UIButton!
//    @IBOutlet var button2: UIButton!
//    @IBOutlet var button3: UIButton!
//    @IBOutlet var button4: UIButton!
//    @IBOutlet var button5: UIButton!
//    @IBOutlet var button6: UIButton!
//    @IBOutlet var button7: UIButton!
//    @IBOutlet var button8: UIButton!
//    @IBOutlet var button9: UIButton!
//    @IBOutlet var button10: UIButton!
//    @IBOutlet var button11: UIButton!
//    @IBOutlet var button12: UIButton!
//    @IBOutlet var button13: UIButton!
//    @IBOutlet var button14: UIButton!
//    @IBOutlet var button15: UIButton!
//    @IBOutlet var button16: UIButton!
//    @IBOutlet var button17: UIButton!
//    @IBOutlet var button18: UIButton!
//    @IBOutlet var button19: UIButton!
//    
//    //ハズレかアタリか表示
//    @IBOutlet var HanteiLabel: UILabel!
//    
//    //どちらの番か表示
//    @IBOutlet var Playerlable: UILabel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        SVProgressHUD.showSuccess(withStatus: "対戦者入室")
//        ref = Database.database().reference()
//        
//        ref.child("users").child((user?.uid)!).observe(.value, with: {(snapShots) in
//            
//            let RoomID = String(describing: snapShots.childSnapshot(forPath: "RoomID").value!)
//            
//            self.userDefault.set(RoomID, forKey: "RoomID")
//            
//            //相手の名前とIDを取得
//            self.ref.child("rooms").child(RoomID).child("message").observe(.childAdded, with: { [weak self](snapshot) -> Void in
//                
//                let HostName = String(describing: snapshot.childSnapshot(forPath: "HostName").value!)
//                let HostID = String(describing: snapshot.childSnapshot(forPath: "HostID").value!)
//                let MemberName = String(describing: snapshot.childSnapshot(forPath: "MemberName").value!)
//                
//                print("ホストの名前は...\(HostName)")
//                print("ホストのIDは...\(HostID)")
//                print("メンバーの名前は...\(MemberName)")
//                
//                self?.userDefault.set(HostName, forKey: "HostName")
//                self?.userDefault.set(MemberName, forKey: "MemberName")
//            })
//            
//            //            //どちらがタップできるか取得
//            //            self.ref.child("rooms").child(RoomID).child("battle").observe(.childAdded, with: { [weak self](snapshot) -> Void in
//            //                print("1")
//            //
//            //                let Tap_Player = String(describing: snapshot.childSnapshot(forPath: "TP").value!)
//            //                print("2")
//            //
//            //                print("今タップできるPlayerは...\(Tap_Player)")
//            //                if Tap_Player == "0" {
//            //                    print("Hostの時")
//            //                    //ボタン無効化
//            //                    self?.button_Disabled()
//            //
//            //                }else if Tap_Player == "1" {
//            //                    print("Memberの時")
//            //                    //ボタン有効化
//            //                    self?.button_Effectiveness()
//            //                }
//            //                print("3")
//            //
//            //            })
//            
//            //            //どのボタンを押したか
//            //            self.ref.child("rooms").child(RoomID).child("battle").child("Tap button").observe(.childAdded, with: { [weak self](snapshot) -> Void in
//            //
//            //                //押したボタンをhogeに代入
//            //                let hoge = String(describing: snapshot.childSnapshot(forPath: "Button").value!)
//            //                print(hoge)
//            
//            //データの読み込み
//            self.ref.child("rooms").child(RoomID).child("battle").child("Tap_button").observe(.childAdded, with: { [weak self](snapshot) -> Void in
//                
//                if hoge == "0" {
//                    if self?.hazure == "0" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button0.isHidden = true
//                }else if hoge == "1" {
//                    if self?.hazure == "1" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button1.isHidden = true
//                }else if hoge == "2" {
//                    if self?.hazure == "2" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button2.isHidden = true
//                }else if hoge == "3" {
//                    if self?.hazure == "3" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button3.isHidden = true
//                }else if hoge == "4" {
//                    if self?.hazure == "4" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button4.isHidden = true
//                }else if hoge == "5" {
//                    if self?.hazure == "5" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button5.isHidden = true
//                }else if hoge == "6" {
//                    if self?.hazure == "6" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button6.isHidden = true
//                }else if hoge == "7" {
//                    if self?.hazure == "7" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button7.isHidden = true
//                }else if hoge == "8" {
//                    if self?.hazure == "8" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button8.isHidden = true
//                }else if hoge == "9" {
//                    if self?.hazure == "9" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button9.isHidden = true
//                }else if hoge == "10" {
//                    if self?.hazure == "10" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button10.isHidden = true
//                }else if hoge == "11" {
//                    if self?.hazure == "11" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button11.isHidden = true
//                }else if hoge == "12" {
//                    if self?.hazure == "12" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button12.isHidden = true
//                }else if hoge == "13" {
//                    if self?.hazure == "13" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button13.isHidden = true
//                }else if hoge == "14" {
//                    if self?.hazure == "14" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button14.isHidden = true
//                }else if hoge == "15" {
//                    if self?.hazure == "15" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button15.isHidden = true
//                }else if hoge == "16" {
//                    if self?.hazure == "16" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button16.isHidden = true
//                }else if hoge == "17" {
//                    if self?.hazure == "17" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button17.isHidden = true
//                }else if hoge == "18" {
//                    if self?.hazure == "18" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    
//                    self?.button18.isHidden = true
//                }else if hoge == "19" {
//                    if self?.hazure == "19" {
//                        self?.Hazure()
//                    }else {
//                        self?.atari()
//                    }
//                    self?.button19.isHidden = true
//                    
//                }
//            }})
//    })
//}
//
////ボタンを押したときの処理
//@IBAction func tap(sender: UIButton) {
//    
//    let RID = userDefault.string(forKey: "RoomID")
//    
//    //押したボタンの数字を送信
//    switch sender.tag {
//    case 0:
//        let messageDate = ["Button" : "0"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 1:
//        let messageDate = ["Button" : "1"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 2:
//        let messageDate = ["Button" : "2"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 3:
//        let messageDate = ["Button" : "3"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 4:
//        let messageDate = ["Button" : "4"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 5:
//        let messageDate = ["Button" : "5"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 6:
//        let messageDate = ["Button" : "6"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 7:
//        let messageDate = ["Button" : "7"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 8:
//        let messageDate = ["Button" : "8"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 9:
//        let messageDate = ["Button" : "9"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 10:
//        let messageDate = ["Button" : "10"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 11:
//        let messageDate = ["Button" : "11"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 12:
//        let messageDate = ["Button" : "12"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 13:
//        let messageDate = ["Button" : "13"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 14:
//        let messageDate = ["Button" : "14"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 15:
//        let messageDate = ["Button" : "15"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 16:
//        let messageDate = ["Button" : "16"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 17:
//        let messageDate = ["Button" : "17"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 18:
//        let messageDate = ["Button" : "18"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    case 19:
//        let messageDate = ["Button" : "19"]
//        ref.child("rooms").child(RID!).child("battle").child("Tap_button").setValue(messageDate)
//    default:
//        print("当てはまらない")
//    }
//}
//
////ボタン有効化
//func button_Effectiveness() {
//    self.button0.isEnabled = true
//    self.button1.isEnabled = true
//    self.button2.isEnabled = true
//    self.button3.isEnabled = true
//    self.button4.isEnabled = true
//    self.button5.isEnabled = true
//    self.button6.isEnabled = true
//    self.button7.isEnabled = true
//    self.button9.isEnabled = true
//    self.button10.isEnabled = true
//    self.button11.isEnabled = true
//    self.button12.isEnabled = true
//    self.button13.isEnabled = true
//    self.button14.isEnabled = true
//    self.button15.isEnabled = true
//    self.button16.isEnabled = true
//    self.button17.isEnabled = true
//    self.button18.isEnabled = true
//    self.button19.isEnabled = true
//}
//
////ボタン無効
//func button_Disabled() {
//    self.button0.isEnabled = false
//    self.button1.isEnabled = false
//    self.button2.isEnabled = false
//    self.button3.isEnabled = false
//    self.button4.isEnabled = false
//    self.button5.isEnabled = false
//    self.button6.isEnabled = false
//    self.button7.isEnabled = false
//    self.button9.isEnabled = false
//    self.button10.isEnabled = false
//    self.button11.isEnabled = false
//    self.button12.isEnabled = false
//    self.button13.isEnabled = false
//    self.button14.isEnabled = false
//    self.button15.isEnabled = false
//    self.button16.isEnabled = false
//    self.button17.isEnabled = false
//    self.button18.isEnabled = false
//    self.button19.isEnabled = false
//}
//
//func atari() {
//    HanteiLabel.text = "セーフ"
//    let when = DispatchTime.now() + 0.5
//    
//    DispatchQueue.main.asyncAfter(deadline: when) {
//        self.HanteiLabel.text = " "
//    }
//}
//
//func Hazure() {
//    // アラートを作成
//    let alert = UIAlertController(
//        title: "fuga",
//        message: "終了",
//        preferredStyle: .alert)
//    
//    // アラートにボタンをつける
//    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)
//    }))
//    
//    // アラート表示
//    self.present(alert, animated: true, completion: nil)
//    
//}
//
//override func didReceiveMemoryWarning() {
//    super.didReceiveMemoryWarning()
//    // Dispose of any resources that can be recreated.
//}
//}
