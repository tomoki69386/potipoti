////
////  RoomViewController.swift
////  potipoti
////
////  Created by 築山朋紀 on 2017/08/19.
////  Copyright © 2017年 築山朋紀. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseDatabase
//import FirebaseAuth
//import SVProgressHUD
//
//class RoomViewController: UIViewController{
//    
//    let userDefault = UserDefaults.standard
//    var ref: DatabaseReference! //Firebase
//    let user = Auth.auth().currentUser
//    var num : Int! //どちらから始めるか決めるのに使う
//    var fuga: Int!
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
//        //ロード画面の表示
//        SVProgressHUD.show()
//        
//        //ボタンを無効化
//        self.button0.isEnabled = false
//        self.button1.isEnabled = false
//        self.button2.isEnabled = false
//        self.button3.isEnabled = false
//        self.button4.isEnabled = false
//        self.button5.isEnabled = false
//        self.button6.isEnabled = false
//        self.button7.isEnabled = false
//        self.button9.isEnabled = false
//        self.button10.isEnabled = false
//        self.button11.isEnabled = false
//        self.button12.isEnabled = false
//        self.button13.isEnabled = false
//        self.button14.isEnabled = false
//        self.button15.isEnabled = false
//        self.button16.isEnabled = false
//        self.button17.isEnabled = false
//        self.button18.isEnabled = false
//        self.button19.isEnabled = false
//        
//        let MemberName = userDefault.string(forKey: "MemberName")
//        let RoomID = userDefault.string(forKey: "ルームID")
//        ref = Database.database().reference()
//        
//        
//        
//        //対戦者の選択待ち
//        self.ref.child("rooms").child(RoomID!).child("messages").observe(.value, with: {(snapShots) in
//            
//            let battle = String(describing: snapShots.childSnapshot(forPath: "対戦").value!)
//            print("対戦は...\(battle)")
//            
//            //ホストとメンバーの名前を取得
//            let HostName = String(describing: snapShots.childSnapshot(forPath: "HostName").value!)
//            let MemberName = String(describing: snapShots.childSnapshot(forPath: "MemberName").value!)
//            
//            if battle == "しない" {
//                //対戦をしない時の処理
//                self.No_battle()
//                
//            }else if battle == "する" {
//                //相手が入室した時の処理
//                SVProgressHUD.showSuccess(withStatus: "対戦者入室")
//            }
//        })
//        
//        //どのボタンを押したか
//        self.ref.child("rooms").child(RoomID!).child("battle").child("Tap button").observe(.childAdded, with: { [weak self](snapshot) -> Void in
//            
//            let hazure = self?.userDefault.integer(forKey: "ハズレ")
//            
//            //Buttonの番号をStringに変換してhogeに代入
//            let hoge = String(describing: snapshot.childSnapshot(forPath: "Button").value!)
//            
//            if hoge == "0" {
//                if hazure == 0 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button0.isHidden = true
//            }else if hoge == "1" {
//                if hazure == 1 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button1.isHidden = true
//            }else if hoge == "2" {
//                if hazure == 2 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button2.isHidden = true
//            }else if hoge == "3" {
//                if hazure == 3 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button3.isHidden = true
//            }else if hoge == "4" {
//                if hazure == 4 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button4.isHidden = true
//            }else if hoge == "5" {
//                if hazure == 5 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button5.isHidden = true
//            }else if hoge == "6" {
//                if hazure == 6 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button6.isHidden = true
//            }else if hoge == "7" {
//                if hazure == 7 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button7.isHidden = true
//            }else if hoge == "8" {
//                if hazure == 8 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button8.isHidden = true
//            }else if hoge == "9" {
//                if hazure == 9 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button9.isHidden = true
//            }else if hoge == "10" {
//                if hazure == 10 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button10.isHidden = true
//            }else if hoge == "11" {
//                if hazure == 11 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button11.isHidden = true
//            }else if hoge == "12" {
//                if hazure == 12 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button12.isHidden = true
//            }else if hoge == "13" {
//                if hazure == 13 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button13.isHidden = true
//            }else if hoge == "14" {
//                if hazure == 14 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button14.isHidden = true
//            }else if hoge == "15" {
//                if hazure == 15 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button15.isHidden = true
//            }else if hoge == "16" {
//                if hazure == 16 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button16.isHidden = true
//            }else if hoge == "17" {
//                if hazure == 17 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button17.isHidden = true
//            }else if hoge == "18" {
//                if hazure == 18 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                
//                self?.button18.isHidden = true
//            }else if hoge == "19" {
//                if hazure == 19 {
//                    self?.make()
//                }else {
//                    self?.atari()
//                }
//                self?.button19.isHidden = true
//            }
//        })
//        
//    }
//    
//    //バトルしない時の処理
//    func No_battle() {
//        let RoomID = userDefault.string(forKey: "ルームID")
//        //ルームの削除
//        self.ref.child("rooms").child(RoomID!).removeValue()
//        print("ルームの削除")
//        
//        //相手のIDを取得
//        let MemberID = self.userDefault.string(forKey: "MemberID")
//        print("相手のIDは...\(MemberID)")
//        
//        //相手のusersにあるRoomIDを削除
//        self.ref.child("users").child(MemberID!).child("RoomID").removeValue()
//        print("MemberのRoomIDを削除")
//        
//        SVProgressHUD.showSuccess(withStatus: "error")
//        
//        //2秒の間待つ
//        let when = DispatchTime.now() + 1
//        //画面遷移
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            //対戦を拒否されたので画面を1つ戻る
//            let alert = UIAlertController(
//                title: "拒否されました",
//                message: "対戦を拒否されたので新しく対戦者を選択して下さい",
//                preferredStyle: .alert)
//            // アラートにボタンをつける
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                self.dismiss(animated: true, completion: nil)
//            }))
//            // アラート表示
//            self.present(alert, animated: true, completion: nil)
//        }
//        print("画面を戻る")
//    }
//    
//    //ボタンを押したときの処理
//    //Buttonに番号を代入
//    @IBAction func tap(sender: UIButton) {
//        let RoomID = userDefault.string(forKey: "ルームID")
//        switch sender.tag {
//        case 0:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 0])
//        case 1:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 1])
//        case 2:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 2])
//        case 3:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 3])
//        case 4:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 4])
//        case 5:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 5])
//        case 6:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 6])
//        case 7:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 7])
//        case 8:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 8])
//        case 9:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 9])
//        case 10:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 10])
//        case 11:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 11])
//        case 12:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 12])
//        case 13:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 13])
//        case 14:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 14])
//        case 15:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 15])
//        case 16:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 16])
//        case 17:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 17])
//        case 18:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 18])
//        case 19:
//            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(["Button": 19])
//        default:
//            print("当てはまらない")
//        }
//    }
//    
//    //ボタン有効化する処理
//    func button_Effectiveness() {
//        self.button0.isEnabled = true
//        self.button1.isEnabled = true
//        self.button2.isEnabled = true
//        self.button3.isEnabled = true
//        self.button4.isEnabled = true
//        self.button5.isEnabled = true
//        self.button6.isEnabled = true
//        self.button7.isEnabled = true
//        self.button9.isEnabled = true
//        self.button10.isEnabled = true
//        self.button11.isEnabled = true
//        self.button12.isEnabled = true
//        self.button13.isEnabled = true
//        self.button14.isEnabled = true
//        self.button15.isEnabled = true
//        self.button16.isEnabled = true
//        self.button17.isEnabled = true
//        self.button18.isEnabled = true
//        self.button19.isEnabled = true
//    }
//    
//    //ボタン無効化する処理
//    func button_Disabled() {
//        self.button0.isEnabled = false
//        self.button1.isEnabled = false
//        self.button2.isEnabled = false
//        self.button3.isEnabled = false
//        self.button4.isEnabled = false
//        self.button5.isEnabled = false
//        self.button6.isEnabled = false
//        self.button7.isEnabled = false
//        self.button9.isEnabled = false
//        self.button10.isEnabled = false
//        self.button11.isEnabled = false
//        self.button12.isEnabled = false
//        self.button13.isEnabled = false
//        self.button14.isEnabled = false
//        self.button15.isEnabled = false
//        self.button16.isEnabled = false
//        self.button17.isEnabled = false
//        self.button18.isEnabled = false
//        self.button19.isEnabled = false
//    }
//    
//    //押したボタンがセーフだった場合の処理
//    func atari() {
//        HanteiLabel.text = "セーフ"
//        let when = DispatchTime.now() + 0.5
//        
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            self.HanteiLabel.text = " "
//        }
//    }
//    
//    //押したボタンが間違いだった場合の処理
//    func make() {
//        // アラートを作成
//        let alert = UIAlertController(
//            title: "fuga",
//            message: "終了",
//            preferredStyle: .alert)
//        
//        // アラートにボタンをつける
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)
//        }))
//        
//        // アラート表示
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//}
