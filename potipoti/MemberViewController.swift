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
import AVFoundation //SE
import AudioToolbox  //バイブレーション

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
    @IBOutlet var Label: UILabel!
    @IBOutlet var hantei: UILabel!
    var viewcount: Bool = false
    
    //音楽再生
    var seikaiplayer:AVAudioPlayer!
    var hazureplayer:AVAudioPlayer!
    let seikaiurl = Bundle.main.bundleURL.appendingPathComponent("正解.mp3")
    let hazureurl = Bundle.main.bundleURL.appendingPathComponent("ハズレ.mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.showSuccess(withStatus: "対戦者入室")
        
        do {
            try seikaiplayer = AVAudioPlayer(contentsOf:seikaiurl)
            //音楽をバッファに読み込んでおく
            seikaiplayer.prepareToPlay()
        } catch {
            print(error)
        }
        
        do {
            try hazureplayer = AVAudioPlayer(contentsOf:hazureurl)
            //音楽をバッファに読み込んでおく
            hazureplayer.prepareToPlay()
        } catch {
            print(error)
        }
        
        //Firebase
        ref = Database.database().reference()
        
        //RoomIDの取得
        self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //RoomIDの宣言
            let RoomID = String(describing: snapshot.childSnapshot(forPath: "RoomID").value!)
            self.userDefault.set(RoomID, forKey: "RoomID")
            
            self.ref.child("rooms").child(RoomID).child("messages").observe(.value, with: {(snapShots) in
                
                //ハズレのボタンを取得
                let LosingButton = String(describing: snapShots.childSnapshot(forPath: "ハズレボタン").value!)
                
                //最初にボタンを押せるユーザーを取得
                let TP = String(describing: snapShots.childSnapshot(forPath: "TP").value!)
                
                let hostName = String(describing: snapShots.childSnapshot(forPath: "HostName").value!)
                
                let memberName = String(describing: snapShots.childSnapshot(forPath: "MemberName").value!)
                
                self.userDefault.set(LosingButton, forKey: "LosingButton")
                
                print("ハズレのボタンは...\(LosingButton)")
                print("ボタンを押せるのは...\(TP)")
                
                if TP == "0" {
                    //hostが押せる時の処理
                    print("ボタンを無効化")
                    self.button_Disabled()
                    self.Label.text = hostName
                    
                }else if TP == "1" {
                    //memberが押せる時の処理
                    print("ボタン有効化")
                    self.button_Effectiveness()
                    self.Label.text = memberName
                }
                //だれがButtonを押したか取得する
                self.button_Reading()
            })
        })
    }
    
    //押したボタンの取得メソッド
    func button_Reading() {
        //ルームIDとハズレボタンの設定
        let roomID = userDefault.string(forKey: "RoomID")
        let LosingButton = userDefault.string(forKey: "LosingButton")
        ref.child("rooms").child(roomID!).child("battle").child("Tap_button").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let button = String(describing: snapshot.childSnapshot(forPath: "button").value!)
            print("Buttonスナップショットデータ\(snapshot)")
            if button != "<null>" {
                //nullじゃなかったら処理する
                print("押したボタンは...\(button)")
                
                if LosingButton == button {
                    self.out()
                }else {
                    self.safe()
                }
                //Buttonの削除する処理を書く
                switch button {
                case "0":
                    self.button0.isHidden = true
                case "1":
                    self.button1.isHidden = true
                case "2":
                    self.button2.isHidden = true
                case "3":
                    self.button3.isHidden = true
                case "4":
                    self.button4.isHidden = true
                case "5":
                    self.button5.isHidden = true
                case "6":
                    self.button6.isHidden = true
                case "7":
                    self.button7.isHidden = true
                case "8":
                    self.button8.isHidden = true
                case "9":
                    self.button9.isHidden = true
                case "10":
                    self.button10.isHidden = true
                case "11":
                    self.button11.isHidden = true
                case "12":
                    self.button12.isHidden = true
                case "13":
                    self.button13.isHidden = true
                case "14":
                    self.button14.isHidden = true
                case "15":
                    self.button15.isHidden = true
                case "16":
                    self.button16.isHidden = true
                case "17":
                    self.button17.isHidden = true
                case "18":
                    self.button18.isHidden = true
                case "19":
                    self.button19.isHidden = true
                default:
                    print("error")
                }
                self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").removeAllObservers()
            }
        })
    }
    
    //セーフの時の処理
    func safe() {
        //SE再生
        seikaiplayer.play()
        hantei.text = "セーフ"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.hantei.text = ""
        }
    }
    
    //ゲーム終了時の処理
    func out() {
        //Firebase
        ref = Database.database().reference()
        
        //バイブレーション
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //SE再生
        hazureplayer.play()
        
        //RoomIDの宣言
        let RoomID = userDefault.string(forKey: "RoomID")
        
        self.ref.child("rooms").child(RoomID!).child("messages").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let TP = String(describing: snapshot.childSnapshot(forPath: "TP").value!)
            let userID = String(describing: snapshot.childSnapshot(forPath: "HostID").value!)
            
            let memberName = String(describing: snapshot.childSnapshot(forPath: "MemberName").value!)
            
            var MS: String!
            
            if TP == "0" {
                //hostが押せる時の処理
                //memberの負け
                MS = "\(memberName)の負け"
                self.ref.child("users").child((self.user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let Defeat_count_String = String(describing: snapshot.childSnapshot(forPath: "Defeat_count").value!)
                    
                    var Defeat_count: Int = Int(Defeat_count_String)!
                    Defeat_count += 1
                    self.ref.child("users").child((self.user?.uid)!).updateChildValues(["Defeat_count": Defeat_count])
                })
                
            }else if TP == "1" {
                //memberが押せる時の処理
                //memberの勝ち
                MS = "\(memberName)の勝ち"
                self.ref.child("users").child((self.user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let Win_count_String = String(describing: snapshot.childSnapshot(forPath: "Win_count").value!)
                    
                    var Win_count: Int = Int(Win_count_String)!
                    Win_count += 1
                    self.ref.child("users").child((self.user?.uid)!).updateChildValues(["Win_count": Win_count])
                })
            }
            
            let hoge = ["button": "<null>"]
            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").updateChildValues(hoge)
            self.button_Reading()
            
            // アラートを作成
            let alert = UIAlertController(
                title: "終了",
                message: MS,
                preferredStyle: .alert)
            
            // アラートにボタンをつける
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
                
                let user = Auth.auth().currentUser
                let name = user?.displayName
                
                //自分のデータを初期値に戻す
                self.ref.child("users").child((self.user?.uid)!).setValue(["username": name,"uid": user?.uid])
                
                //observerを削除する
                self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").removeAllObservers()
                
                //ルームを削除する
                self.ref.child("rooms").child(RoomID!).removeValue()
                print("ルームを削除")
            })
            )
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    //ボタンを押した時の処理
    @IBAction func tap(sender: UIButton) {
        
        let roomID = userDefault.string(forKey: "RoomID")
        
        if roomID != "<null>" {
            //hogeに押したボタンを入れる
            let hoge = ["button": sender.tag]
            self.ref.child("rooms").child(roomID!).child("battle").child("Tap_button").updateChildValues(hoge)
            
            //次にボタンを押せる人をHostにする
            self.ref.child("rooms").child(roomID!).child("messages").updateChildValues(["TP": 0])
        }
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
