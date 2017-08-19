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
    var UserArray: [String] = [] //データを収納する配列
    var ref: DatabaseReference! //Firebase
    var snap: DataSnapshot! //FetchしたSnapshotsを格納する変数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //データを取得
        ref = Database.database().reference()
        self.ref?.child("Active_users").observe(.childAdded, with: { [weak self](snapshot) -> Void in
            let username = String(describing: snapshot.childSnapshot(forPath: "username").value!)
            print(username)
            self?.UserArray.append(username)
            
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
        return UserArray.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = (UserArray[indexPath.row])
        
        return UITableViewCell()
    }
    
    // セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ref = Database.database().reference()
        self.ref?.child("Active_users").observe(.childAdded, with: { [weak self](snapshot) -> Void in
            let username = String(describing: snapshot.childSnapshot(forPath: "username").value!)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
