//
//  ProfileViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/08/12.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

//名前とプロフィール画像の設定する画面

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var button1: UIButton!
    @IBOutlet var TableView: UITableView!
    
    let userDefault = UserDefaults.standard
    var ref: DatabaseReference!
    let Array = ["hoge","fuga","piyo","ログアウト"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        
        userNameLabel.text = (user?.displayName)
        
        button1.layer.borderWidth = 1
        button1.layer.cornerRadius = 5
        
        TableView.delegate = self
        
    }
    
    //画面を開いたとき
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppearを処理する")
        
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        
        if (UserDefaults.standard.object(forKey: "MyPhoto") != nil) {
            print("データ有り")
            let imageDate:NSData = UserDefaults.standard.object(forKey: "MyPhoto") as! NSData
            ImageView.image = UIImage(data:imageDate as Data)
        }else {
            print("データ無し")
            
        }
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://potipoti-e1d0e.appspot.com/image")
        
        if ImageView.image == nil {
            print("UIImageViewに画像がないとき")
            // Create a reference to the file you want to download
            let islandRef = storageRef.child("\(uid).jpg")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            islandRef.getData(maxSize: 50 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error)
                    self.Alert()
                } else {
                    // Data for "images/island.jpg" is returned
                    self.ImageView.image = UIImage(data: data!)
                    self.self.userDefault.set(UIImagePNGRepresentation(self.ImageView.image!), forKey: "MyPhoto")
                    print("imageを保存")
                    print("imageを表示した")
                }
            }
        }else {
            print("UIImageViewに画像をあるとき")
        }
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array.count
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // セルに表示する値を設定する
        cell.textLabel!.text = Array[indexPath.row]
        
        return UITableViewCell()
    }
    
    // セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            print("hoge")
        }else if indexPath.row == 1 {
            print("fuga")
        }else if indexPath.row == 2 {
            print("piyo")
        }else if indexPath.row == 3 {
            //ログアウト
            self.signOut()
        }
    }
    
    //サインアウトのメソッド
    func signOut() {
        print("サインアウトボタンを押した")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("サインアウト出来ました")
            
            userDefault.removeObject(forKey: "MyPhoto")
            
            //画面遷移
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(nextView, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("サインアウト時にエラーが発生しました",signOutError)
        }
    }
    
    func Alert() {
        // アラートを作成
        let alert = UIAlertController(
            title: "注意！",
            message: "プロフィール画像が設定されていません",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "設定する", style: .default, handler: { action in
            let storyboard:UIStoryboard =  UIStoryboard(name: "Main",bundle:nil)
            
            let nextView = storyboard.instantiateViewController(withIdentifier: "Profile_EditViewController") as! Profile_EditViewController
            self.present(nextView, animated: true, completion: nil)
        }))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
