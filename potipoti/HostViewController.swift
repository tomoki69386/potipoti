//
//  HostViewController.swift
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
import AVFoundation
import AudioToolbox
import TwitterKit
import Social

class HostViewController: UIViewController {
    
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
    @IBOutlet var Label: UILabel!
    @IBOutlet var hantei: UILabel!
    
    var ref: DatabaseReference!
    let user = Auth.auth().currentUser
    let userDefault = UserDefaults.standard
    var count = false
    var timer: Timer = Timer()
    var number: Int = 1
    
    //音楽再生
    var seikaiplayer:AVAudioPlayer!
    var hazureplayer:AVAudioPlayer!
    let seikaiurl = Bundle.main.bundleURL.appendingPathComponent("正解.mp3")
    let hazureurl = Bundle.main.bundleURL.appendingPathComponent("ハズレ.mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ロード画面の表示
        SVProgressHUD.show()
        
        //カウントダウンのスタート
        self.time()
        
        //SEの設定
        do {
            try seikaiplayer = AVAudioPlayer(contentsOf:seikaiurl)
            //音楽をバッファに読み込んでおく
            seikaiplayer.prepareToPlay()
        } catch {
            print("インスタンスエラー...\(error)")
        }
        
        do {
            try hazureplayer = AVAudioPlayer(contentsOf:hazureurl)
            //音楽をバッファに読み込んでおく
            hazureplayer.prepareToPlay()
        } catch {
            print("インスタンスエラー...\(error)")
        }
        
        //Firebase
        ref = Database.database().reference()
        
        //RoomIDの取得
        self.ref.child("users").child((user?.uid)!).observe(.value, with: {(snapShots) in
            
            //RoomIDの宣言
            let RoomID = String(describing: snapShots.childSnapshot(forPath: "RoomID").value!)
            self.userDefault.set(RoomID, forKey: "RoomID")
        
            print("ルームIDは...\(RoomID)")
            
            //対戦者の選択待ち
            self.ref.child("rooms").child(RoomID).child("messages").observe(.value, with: {(snapShots) in
                
                let battle = String(describing: snapShots.childSnapshot(forPath: "対戦").value!)
                
                let LosingButton = String(describing: snapShots.childSnapshot(forPath: "ハズレボタン").value!)
                
                //ハズレボタンを保存する
                self.userDefault.set(LosingButton, forKey: "LosingButton")
                
                let TP = String(describing: snapShots.childSnapshot(forPath: "TP").value!)
                
                let hostName = String(describing: snapShots.childSnapshot(forPath: "HostName").value!)
                
                let memberName = String(describing: snapShots.childSnapshot(forPath: "MemberName").value!)
                
                print("ハズレのボタンは...\(LosingButton)")
                print("最初にボタンを押せるのは...\(TP)")
                
                if battle == "しない" {
                    //対戦をしない時の処理
                    self.No_battle()
                    //ルームの削除
                    self.ref.child("rooms").child(RoomID).removeValue()
                    return
                    
                }else if battle == "する" {
                    //タイマーのカウントをストップさせる
                    self.timer.invalidate()
                    self.ref.child("users").child((self.user?.uid)!).updateChildValues(["App": 0])
                    
                    if self.count == false {
                        //相手が入室した時の処理
                        SVProgressHUD.showSuccess(withStatus: "対戦者入室")
                        self.count = true
                    }
                    
                    if TP == "0" {
                        //hostが押せる時の処理
                        print("ボタンを有効化")
                        self.button_Effectiveness()
                        self.Label.text = hostName
                        
                    }else if TP == "1" {
                        //memberが押せる時の処理
                        print("ボタンを無効化")
                        self.button_Disabled()
                        self.Label.text = memberName
                    }
                    //押したButtonの取得
                    self.button_Reading()
                }
            })
        })
    }
    
    func time() {
        if !timer.isValid {
            //タイマーが動作していなかったら動かす
            timer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(self.up),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    func up() {
        print("カウントダウン...\(number)")
        if number < 13 {
            //13未満の時の処理
            //numberに1を足す
            number += 1
        }else {
            //13以上の時の処理
            //待機の制限時間が来た時の処理
            //バトルをしない時の処理
            No_battle()
            
            //タイマーを停止する
            if timer.isValid {
                timer.invalidate()
            }
        }
    }
    
    //ボタン取得メソッド
    func button_Reading() {
        let roomID = userDefault.string(forKey: "RoomID")
        let LosingButton = userDefault.string(forKey: "LosingButton")

        //一回ずつ取得
        ref.child("rooms").child(roomID!).child("battle").child("Tap_button").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let button = String(describing: snapshot.childSnapshot(forPath: "button").value!)

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
            }
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    //セーフ時の処理
    func safe() {
        //SE再生
        seikaiplayer.play()
        hantei.text = "セーフ"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hantei.text = " "
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
            
            let hostName = String(describing: snapshot.childSnapshot(forPath: "HostName").value!)
            
            var MS: String!
            
            if TP == "0" {
                //hostが押せる時の処理
                //hostの勝ち
                MS = "\(hostName)の勝ち"
                //Win_countを取得
                //Win_countに+1
                self.ref.child("users").child((self.user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let Win_count_String = String(describing: snapshot.childSnapshot(forPath: "Win_count").value!)
                    //Int型に変更する
                    var Win_count: Int = Int(Win_count_String)!
                    Win_count += 1
                    //+1にしたあと送信する
                    //Appを1にして対戦受け入れ可能にする
                    self.ref.child("users").child((self.user?.uid)!).updateChildValues(["Win_count": Win_count, "App": "1", "RoomID": "<null>"])
                })
                
            }else if TP == "1" {
                //memberが押せる時の処理
                //hostの負け
                MS = "\(hostName)の負け"
                //Defeat_countを取得
                //Defeat_countに+1
                self.ref.child("users").child((self.user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let Defeat_count_String = String(describing: snapshot.childSnapshot(forPath: "Defeat_count").value!)
                    
                    //Int型に変更する
                    var Defeat_count: Int = Int(Defeat_count_String)!
                    Defeat_count += 1
                    //+1にしたあと送信する
                    //Appを1にして対戦受け入れ可能にする
                    self.ref.child("users").child((self.user?.uid)!).updateChildValues(["Defeat_count": Defeat_count, "App": "1", "RoomID": "<null>"])
                })
            }

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
                
                //observerを削除する
                self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").removeAllObservers()
                
                //ルームの削除
                self.ref.child("rooms").child(RoomID!).removeValue()
            }))
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    //ボタンを押した時の処理
    @IBAction func tap(sender: UIButton) {
        //RoomIDの取得
        self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //RoomIDの宣言
            let roomID = String(describing: snapshot.childSnapshot(forPath: "RoomID").value!)
            
            if roomID != "<null>" {
                //hogeに押したボタンの番号を入れる
                let hoge = ["button": sender.tag]
                
                self.ref.child("rooms").child(roomID).child("battle").child("Tap_button").updateChildValues(hoge)
                
                //次にボタンを押せる人をMemberにする
                self.ref.child("rooms").child(roomID).child("messages").updateChildValues(["TP": 1])
            }
        })
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
    
    //バトルしない時の処理
    func No_battle() {
        //RoomIDの宣言
        let RoomID = userDefault.string(forKey: "RoomID")
        
        //相手のIDを一回だけ取得
        self.ref.child("rooms").child(RoomID!).child("messages").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //メンバーIDを宣言
            let MemberID = String(describing: snapshot.childSnapshot(forPath: "MamberID").value!)
            
            //ルームの削除
            self.ref.child("rooms").child(RoomID!).removeValue()
            
            //相手のデータベースにあるRoomIDをアップデート
            self.ref.child("users").child(MemberID).updateChildValues(["RoomID": "<null>"])
            
            //自分のデータベースにあるRoomIDもアップデート
            self.ref.child("users").child((self.user?.uid)!).updateChildValues(["RoomID": "<null>", "App": 1])
            
            SVProgressHUD.showSuccess(withStatus: "error")
            
            //2秒の間待つ
            let when = DispatchTime.now() + 1
            //2秒後にアラートを表示
            DispatchQueue.main.asyncAfter(deadline: when) {
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
            }
            print("画面を戻る")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
