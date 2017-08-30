//
//  PlayerViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/08/16.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var TableView: UITableView! //データを表示するtableView
    var MemberNameArray: [String] = [] //データを収納する配列
    var MemberIDArray: [String] = [] //userIDを収納する配列
    var ref: DatabaseReference! //Firebase
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    let userDefault = UserDefaults.standard
    let user = Auth.auth().currentUser
    var memberID: String!
    var RoomID: Int!//RoomID
    var hazure: Int!//ハズレのボタン
    var Tap_Player: Int!//ボタンを押せるプレイヤーを選ぶ
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //データを取得
        ref = Database.database().reference()
        self.ref?.child("users").observe(.childAdded, with: { [weak self](snapshot) -> Void in
            //hostの名前
            let username = String(describing: snapshot.childSnapshot(forPath: "username").value!)
            //hostのID
            let userID = String(describing: snapshot.childSnapshot(forPath: "uid").value!)
            //ルームに入ってるか検索
            let inRoom = String(describing: snapshot.childSnapshot(forPath: "inRoom").value!)
            //表示
            print(username)
            print(userID)
            print(inRoom)
            
            //memberのデータを配列に収納
            self?.MemberNameArray.append(username) //取得したuserの名前を収納する
            self?.MemberIDArray.append(userID) //取得したuserのIDを収納する
            
            //リロード
            self?.TableView.reloadData()
        })
        //デリゲートをセット
        TableView.delegate = self
        TableView.dataSource = self
    }
    
    //画面を閉じた時に処理する
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemberNameArray.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = MemberNameArray[indexPath.row]
        
        return cell
    }
    
    // セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //memberのIDと名前をprint
        print("相手のIDは...\(MemberIDArray[indexPath.row])")
        print("相手の名前は...\(MemberNameArray[indexPath.row])")
        //memberIDを代入
        memberID = MemberIDArray[indexPath.row]
        
        ref = Database.database().reference()
        //RoomIDを決める
        RoomID = Int(arc4random_uniform(100000))
        //ハズレのボタンを決める
        hazure = Int(arc4random_uniform(19))
        
        //RoomIDとハズレのボタンを表示
        print("ルームIDは...\(RoomID)")
        print("ハズレのボタンは...\(hazure)")
        
        //最初にタップできるユーザーを決める
        Tap_Player = Int(arc4random_uniform(1))
        
        //Roomの作成
        //RoomIDは乱数(number)
        //Roomに必要なデータを保存
        self.ref.child("rooms").child(String(RoomID)).child("messages").setValue(
            ["roomID": RoomID, "MamberID": MemberIDArray[indexPath.row], "MemberName": MemberNameArray[indexPath.row], "HostName": user?.displayName, "HostID": user?.uid, "ハズレボタン": hazure, "TP": Tap_Player])
        
        //相手にRoomIDを教える
        ref.child("users").child(MemberIDArray[indexPath.row]).updateChildValues(["RoomID": RoomID,])
        
        //自分のデータにRoomIDを追加する
        ref.child("users").child((user?.uid)!).updateChildValues(["RoomID": RoomID, "inRoom": "true"])
        
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
