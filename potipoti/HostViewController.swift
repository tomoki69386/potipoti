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
import AudioToolbox //バイブレーション

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
    
    var ref: DatabaseReference! //Firebase
    let user = Auth.auth().currentUser
    let userDefault = UserDefaults.standard
    @IBOutlet var Label: UILabel!
    @IBOutlet var hantei: UILabel!
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
                
                self.userDefault.set(LosingButton, forKey: "LosingButton")
                
                let TP = String(describing: snapShots.childSnapshot(forPath: "TP").value!)
                
                let hostName = String(describing: snapShots.childSnapshot(forPath: "HostName").value!)
                
                let memberName = String(describing: snapShots.childSnapshot(forPath: "MemberName").value!)
                
                print("ハズレのボタンは...\(LosingButton)")
                print("最初にボタンを押せるのは...\(TP)")
                print("対戦は...\(battle)")
                
                if battle == "しない" {
                    //対戦をしない時の処理
                    self.No_battle()
                    
                }else if battle == "する" {
                    //タイマーのカウントをストップさせる
                    self.timer.invalidate()
                    
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
        if number < 60 {
            //60未満の時の処理
            //numberに1を足す
            number += 1
        }else {
            //60以上の時の処理
            //待機の制限時間が来た時の処理
            //バトルをしない時の処理を行う
            No_battle()
        }
    }
    
    //ボタン取得メソッド
    func button_Reading() {
        print("ボタン取得メソッド")
        let roomID = userDefault.string(forKey: "RoomID")
        let LosingButton = userDefault.string(forKey: "LosingButton")
        ref.child("rooms").child(roomID!).child("battle").child("Tap_button").observe(.value, with: {(snapShots) in
            
            let button = String(describing: snapShots.childSnapshot(forPath: "button").value!)
            
            
            if button != "<null>" {
                //nullじゃなかったら処理する
                print("押したボタンは...\(button)")
                
                if button == "0" {
                    if LosingButton == "0" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button0.isHidden = true
                    
                }else if button == "1" {
                    if LosingButton == "1" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button1.isHidden = true
                    
                }else if button == "2" {
                    if LosingButton == "2" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button2.isHidden = true
                    
                }else if button == "3" {
                    if LosingButton == "3" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button3.isHidden = true
                    
                }else if button == "4" {
                    if LosingButton == "4" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button4.isHidden = true
                    
                }else if button == "5" {
                    if LosingButton == "5" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button5.isHidden = true
                    
                }else if button == "6" {
                    if LosingButton == "6" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button6.isHidden = true
                    
                }else if button == "7" {
                    if LosingButton == "7" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button7.isHidden = true
                    
                }else if button == "8" {
                    if LosingButton == "8" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button8.isHidden = true
                    
                }else if button == "9" {
                    if LosingButton == "9" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button9.isHidden = true
                    
                }else if button == "10" {
                    if LosingButton == "10" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button10.isHidden = true
                    
                }else if button == "11" {
                    if LosingButton == "11" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button11.isHidden = true
                    
                }else if button == "12" {
                    if LosingButton == "12" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button12.isHidden = true
                    
                }else if button == "13" {
                    if LosingButton == "13" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button13.isHidden = true
                    
                }else if button == "14" {
                    if LosingButton == "14" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button14.isHidden = true
                    
                }else if button == "15" {
                    if LosingButton == "15" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button15.isHidden = true
                    
                }else if button == "16" {
                    if LosingButton == "16" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button16.isHidden = true
                    
                }else if button == "17" {
                    if LosingButton == "17" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button17.isHidden = true
                    
                }else if button == "18" {
                    if LosingButton == "18" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button18.isHidden = true
                    
                }else if button == "19" {
                    if LosingButton == "19" {
                        self.out()
                    }else {
                        self.safe()
                    }
                    self.button19.isHidden = true
                }
            }
        })
    }
    
    func safe() {
        seikaiplayer.play()
        hantei.text = "セーフ"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hantei.text = " "
        }
    }
    
    func out() {
        //Firebase
        ref = Database.database().reference()
        
        //バイブレーション
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //サウンド再生
        hazureplayer.play()
        
        //RoomIDの宣言
        let RoomID = userDefault.string(forKey: "RoomID")
        
        self.ref.child("rooms").child(RoomID!).child("messages").observe(.value, with: {(snapShots) in
            
            let TP = String(describing: snapShots.childSnapshot(forPath: "TP").value!)
            
            let hostName = String(describing: snapShots.childSnapshot(forPath: "HostName").value!)
            
            let memberName = String(describing: snapShots.childSnapshot(forPath: "MemberName").value!)
            
            var MS: String!
            
            if TP == "0" {
                //hostが押せる時の処理
                //hostの勝ち
                MS = "\(hostName)の勝ち"
                
            }else if TP == "1" {
                //memberが押せる時の処理
                //hostの負け
                MS = "\(hostName)の負け"
            }
            
            let hoge = ["button": "<null>"]
            self.ref.child("rooms").child(RoomID!).child("battle").child("Tap_button").setValue(hoge)
            self.button_Reading()
            
            // アラートを作成
            let alert = UIAlertController(
                title: "終了",
                message: MS,
                preferredStyle: .alert)
            
            // アラートにボタンをつける
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
                
                //ルームの削除
                self.ref.child("rooms").child(RoomID!).child("bettle").child("Tap_button").removeValue()
                
                self.ref.child("rooms").child(RoomID!).child("battle").removeValue()
                
                self.ref.child("rooms").child(RoomID!).child("messages").removeValue()
                
                self.ref.child("rooms").child(RoomID!).removeValue()
                print("ルームを削除")
                
                let user = Auth.auth().currentUser
                let name = user?.displayName
                
                self.ref.child("users").child((user?.uid)!).setValue(["username": name,"uid": user?.uid])
            })
            )
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    //ボタンを押した時の処理
    @IBAction func tap(sender: UIButton) {
        //RoomIDの取得
        self.ref.child("users").child((user?.uid)!).observe(.value, with: {(snapShots) in
            
            //RoomIDの宣言
            let roomID = String(describing: snapShots.childSnapshot(forPath: "RoomID").value!)
            
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
        
        //ルームの削除
        self.ref.child("rooms").child(RoomID!).removeValue()
        
        //相手のIDを取得
        self.ref.child("rooms").child(RoomID!).child("messages").observe(.value, with: {(snapShots) in
            
            //メンバーIDを宣言
            let MemberID = String(describing: snapShots.childSnapshot(forPath: "MamberID").value!)
            
            //相手のデータベースにあるRoomIDを削除
            self.ref.child("users").child(MemberID).child("RoomID").removeValue()
            
            //自分のデータベースにあるRoomIDも削除
            self.ref.child("users").child((self.user?.uid)!).child("RoomID").removeValue()
            
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
