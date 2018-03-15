//
//  PlayerViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/08/16.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD
import AVFoundation
import AudioToolbox

class PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var TableView: UITableView! //データを表示するtableView
    var MemberNameArray: [String] = [] //データを収納する配列
    var MemberIDArray: [String] = [] //userIDを収納する配列
    var Defeat_countArray: [String] = []
    var Win_countArray: [String] = []
    var Array: [String] = []
    var ref: DatabaseReference! //Firebase
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    let userDefault = UserDefaults.standard
    let user = Auth.auth().currentUser
    var memberID: String!
    var RoomID: Int!//RoomID
    var hazure: Int!//ハズレのボタン
    var Tap_Player: Int!//ボタンを押せるプレイヤーを選ぶ
    var timer: Timer = Timer()
    //trueならアラートを表示中、falseならアラートを表示していない
    var Existence: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ユーザー一覧を取得する
        self.userreloadDate()
        
        //カウントダウンのスタート
        self.time()
        
        //デリゲートをセット
        TableView.delegate = self
        TableView.dataSource = self
        
        ref = Database.database().reference()
        //変更があれば処理する
        ref.child("users").child((user?.uid)!).observe(.value, with: {(snapShots) in
            
            let RoomID = String(describing: snapShots.childSnapshot(forPath: "RoomID").value!)
            
            if RoomID != "<null>" {
                //nullじゃない時の処理
                print("RoomIDは...\(RoomID)")
                //対戦の挑戦状が届いたことを画面にアラートで表示
                let Alert = UIAlertController(title: "対戦しますか？",message: "対戦の挑戦状が届きました、通信対戦をしますか？", preferredStyle: UIAlertControllerStyle.alert)
                
                //アラートを表示したのでExistenceをtrueに変える
                self.Existence = true
                
                let battle = UIAlertAction(title: "承諾", style:UIAlertActionStyle.default){
                    (action: UIAlertAction) in
                    // 以下はボタンがクリックされた時の処理
                    //通信対戦画面に画面遷移
                    print("承諾をタップした")
                    
                    //アラートのボタンを押したのでExistenceをfalseに変える
                    self.Existence = false
                    
                    //EnemyRoomViewに画面遷移
                    let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "MemberViewController" ) as! MemberViewController
                    self.present( targetViewController, animated: true, completion: nil)
                    
                    //ルームに入ったことをのデータを追加
                    self.ref.child("rooms").child(RoomID).child("messages").updateChildValues(["対戦": "する"])
                }
                
                let cancel = UIAlertAction(title: "拒否", style:UIAlertActionStyle.cancel){
                    (action: UIAlertAction) in
                    // 以下はボタンがクリックされた時の処理
                    //拒否したことを伝える
                    print("拒否をタップした")
                    
                    //アラートのボタンを押したのでExistenceをfalseに変える
                    self.Existence = false
                    
                    //拒否したことを伝える
                    self.ref.child("rooms").child(RoomID).child("messages").updateChildValues(["対戦": "しない"])
                }
                
                //部品をアラートコントローラーに追加していく
                Alert.addAction(battle)//battleを追加
                Alert.addAction(cancel)//cancelを追加
                
                //アラートを表示
                self.present(Alert,animated: true, completion: nil)
                
                //アラートを表示してから13秒経てばアラートを閉じる
                let when = DispatchTime.now() + 13
                //アラートを閉じる
                DispatchQueue.main.asyncAfter(deadline: when) {
                    Alert.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    func time() {
        if !timer.isValid {
            //タイマーが動作していなかったら動かす
            timer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(self.userreloadDate),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    func up() {
        
    }
    
    //リロードButton
    @IBAction func reload() {
        self.userreloadDate()
    }
    
    //ユーザー一覧を取得する
    func userreloadDate() {
        //配列の中身を消してから更新する
        MemberIDArray.removeAll()
        MemberNameArray.removeAll()
        Defeat_countArray.removeAll()
        Win_countArray.removeAll()
        //データを取得
        ref = Database.database().reference()
        self.ref?.child("users").observe(.childAdded, with: { [weak self](snapshot) -> Void in
            
            let username = String(describing: snapshot.childSnapshot(forPath: "username").value!)
            let userID = String(describing: snapshot.childSnapshot(forPath: "uid").value!)
            let App = String(describing: snapshot.childSnapshot(forPath: "App").value!)
            let Defeat_count = String(describing: snapshot.childSnapshot(forPath: "Defeat_count").value!)
            let Win_count = String(describing: snapshot.childSnapshot(forPath: "Win_count").value!)
            
            //オンラインのユーザーだけをTableViewに表示する
            if App == "1" && userID != self?.user?.uid {
                //配列の先頭に値を代入する
                self?.MemberNameArray.insert(username, at: 0) //収録したuserの名前を収納する
                self?.MemberIDArray.insert(userID, at: 0) //取得したuserのIDを収納する
                self?.Defeat_countArray.insert(Defeat_count, at: 0)
                self?.Win_countArray.insert(Win_count, at: 0)
                //リロード
                self?.TableView.reloadData()
            }
        })
    }
    
    //画面を閉じた時に処理する
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ref.removeAllObservers()
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemberNameArray.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        //Int型に変更する
        let hoge: Int = Int(Win_countArray[indexPath.row])!
        let fuga: Int = Int(Defeat_countArray[indexPath.row])!
        
        let text = ("\(MemberNameArray[indexPath.row])さん:  \(hoge)勝\(fuga)敗")
        
        // セルに表示する値を設定する
        cell.textLabel!.text = text
        
        return cell
    }
    
    // セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //memberのIDと名前を表示
        print("相手のIDは...\(MemberIDArray[indexPath.row])")
        print("相手の名前は...\(MemberNameArray[indexPath.row])")
        //memberIDを代入
        memberID = MemberIDArray[indexPath.row]
        //Firebaseの設定
        ref = Database.database().reference()
        //RoomIDを決める
        RoomID = Int(arc4random_uniform(100000))
        //ハズレのボタンを決める
        hazure = Int(arc4random_uniform(19))
        
        //RoomIDとハズレのボタンを表示
        print("ルームIDは...\(RoomID)")
        print("ハズレのボタンは...\(hazure)")
        
        //最初にタップできるユーザーを決める
        Tap_Player = Int(arc4random_uniform(2))
        
        //Roomに必要なデータを保存
        self.ref.child("rooms").child(String(RoomID)).child("messages").updateChildValues(
            ["roomID": RoomID, "MamberID": MemberIDArray[indexPath.row], "MemberName": MemberNameArray[indexPath.row], "HostName": user?.displayName, "HostID": user?.uid, "ハズレボタン": hazure, "TP": Tap_Player])
        
        //相手にRoomIDを教える
        ref.child("users").child(MemberIDArray[indexPath.row]).updateChildValues(["RoomID": RoomID,])
        
        //自分のデータにRoomIDを追加する
        ref.child("users").child((user?.uid)!).updateChildValues(["RoomID": RoomID, "App": 0])
        
        //SecondViewControllerへ遷移するSegueを呼び出す
        performSegue(withIdentifier: "toRoomViewController",sender: nil)
    }
    //画面遷移
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toRoomViewController") {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
