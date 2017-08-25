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
    var enemyNameArray: [String] = [] //データを収納する配列
    var enemyIDArray: [String] = [] //userIDを収納する配列
    var ref: DatabaseReference! //Firebase
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    let userDefault = UserDefaults.standard
    let user = Auth.auth().currentUser
    var enemyID: String!
    var number: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //データを取得
        ref = Database.database().reference()
        self.ref?.child("users").observe(.childAdded, with: { [weak self](snapshot) -> Void in
            let username = String(describing: snapshot.childSnapshot(forPath: "username").value!)
            let userID = String(describing: snapshot.childSnapshot(forPath: "uid").value!)
            let inRoom = String(describing: snapshot.childSnapshot(forPath: "inRoom").value!)
            print(username)
            print(userID)
            print(inRoom)
            
            //ルームに入ってないユーザーだけ配列に追加していく
            if inRoom == "false" {
                //ルームに入ってないユーザーから自分を抜いて配列に入れる
                if self?.user?.uid == userID {
                    self?.enemyNameArray.append(username) //取得したuserの名前を収納する
                    self?.enemyIDArray.append(userID) //取得したuserのIDを収納する
                }
            }
            
            
            self?.TableView.reloadData() //リロード
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
        return enemyNameArray.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = enemyNameArray[indexPath.row]
        
        return cell
    }
    
    // セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("相手のIDは...\(enemyIDArray[indexPath.row])")
        print("相手の名前は...\(enemyNameArray[indexPath.row])")
        enemyID = enemyIDArray[indexPath.row]
        
        ref = Database.database().reference()
        number = Int(arc4random_uniform(100000))
        
        print(number) //乱数
        userDefault.set(number, forKey: "ルームID")
        
        //Roomの作成
        //RoomIDは乱数(number)
        //Roomに必要なデータを保存
        self.ref.child("rooms").child(String(number)).child("messages").setValue(["roomID": number, "enemyID": enemyIDArray[indexPath.row], "enemyName": enemyNameArray[indexPath.row], "myName": user?.displayName, "myID": user?.uid])
        
        //相手にRoomIDを教える
        self.ref.child("users").child(enemyIDArray[indexPath.row]).updateChildValues(["RoomID": number,])
        
        //相手のIDを保存しておく
        userDefault.set(enemyIDArray[indexPath.row], forKey: "enemyID")
        
        //自分のデータのinRoomに対戦中であることを書く
        self.ref.child("users").child((user?.uid)!).updateChildValues(["inRoom": "true"])
        
        // 8. SecondViewControllerへ遷移するSegueを呼び出す
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
