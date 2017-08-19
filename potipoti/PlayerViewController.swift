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
    var UserArray: [DataSnapshot] = [] //データを収納する配列
    var ref: DatabaseReference! //Firebase
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let userName = user?.displayName
        
        _ = Auth.auth().addStateDidChangeListener() { (auth, user) in
            if Auth.auth().currentUser != nil {
                print("ログイン中のユーザーの名前は\(userName)でIDは\(uid)です")
            } else {
                print("ログイン中のユーザーはいません")
            }
        }
        
        self.read() //データを読み込み
        
        //デリゲートをセット
        TableView.delegate = self
        TableView.dataSource = self
    }
    
    //画面を閉じた時に処理する
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        ref.removeAllObservers()
    }
    
    func read () {
        ref = Database.database().reference()
        
        ref.child((Auth.auth().currentUser?.uid)!).observe(.value, with: {(snapShots) in
            if snapShots.children.allObjects is [DataSnapshot] {
                print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                
                print("snapShot...\(snapShots)") //読み込んだデータをプリント
                
                self.snap = snapShots
                
            }
            self.reload(snap: self.snap)
        })
    }
    
    //読み込んだデータは最初すべてのデータが一つにまとまっているので、それらを分割して、配列に入れる
    func reload(snap: DataSnapshot) {
        if snap.exists() {
            print(snap)
            //FIRDataSnapshotが存在するか確認
            UserArray.removeAll()
            //1つになっているFIRDataSnapshotを分割し、配列に入れる
            for item in snap.children {
                UserArray.append(item as! DataSnapshot)
            }
            // ローカルのデータベースを更新
            ref.child((Auth.auth().currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            TableView.reloadData()
        }
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserArray.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = String(describing: UserArray[indexPath.row])
        
        return UITableViewCell()
    }
    
    // セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
