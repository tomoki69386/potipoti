//
//  ProfileViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2018/03/17.
//  Copyright © 2018年 築山朋紀. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD
import AVFoundation
import AudioToolbox
import TwitterKit //ios11用
import Social //ios10以下用

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ImageView = UIImageView()
    let userNameLabel = UILabel()
    let button1 = UIButton()
    let TableView = UITableView()
    
    var userId: String?//Twitter
    
    let userDefault = UserDefaults.standard
    var ref: DatabaseReference!
    let Array = ["フィードバック","対戦成績","ログアウト"]
    
    //trueならアラートを表示中、falseならアラートを表示していない
    var Existence: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let heght = self.view.frame.height
        
        if heght == 812.0 {
            self.iPhoneXsetUI()
        }else {
            self.setUI()
        }
        
        //オンライン対戦の挑戦が来たの処理
        self.onlineBattle()
        
    }
    
    func setUI() {
        //スクリーンサイズ
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        
        //tabBarのサイズ取得
        let tabBarController: UITabBarController = UITabBarController()
        let tabBarHeight = tabBarController.tabBar.frame.size.height
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        
        let buttonSize = screenWidth / 4
        let user = Auth.auth().currentUser
        
        ImageView.frame = CGRect(x: buttonSize, y: statusbarHeight, width: buttonSize * 2, height: buttonSize * 2)
        userNameLabel.frame = CGRect(x: 0, y: statusbarHeight + buttonSize * 2, width: screenWidth, height: buttonSize / 2)
        button1.frame = CGRect(x: buttonSize, y: statusbarHeight + buttonSize * 2 + buttonSize / 2, width: buttonSize * 2, height: buttonSize / 2)
        TableView.frame = CGRect(x: 0, y: statusbarHeight + buttonSize * 2 + buttonSize, width: screenWidth, height: screenWidth - (statusbarHeight + buttonSize * 2 + buttonSize))
        
        //テキストを設定する
        button1.setTitle("プロフィールを変更する", for: .normal)
        userNameLabel.text = user?.displayName
        userNameLabel.textAlignment = NSTextAlignment.center
        
        //テキストのカラーを設定する
        button1.setTitleColor(UIColor.black, for: .normal)
        userNameLabel.textColor = UIColor.black
        
        //ボタンを枠丸にする
        button1.layer.cornerRadius = 5
        ImageView.layer.cornerRadius = self.ImageView.frame.width / 2
        
        //ボタンに幅を付ける
        button1.layer.borderWidth = 1
        
        //ボタンの幅のカラーを設定する
        button1.layer.borderColor = UIColor.black.cgColor
        
        //viewに追加する
        self.view.addSubview(button1)
        self.view.addSubview(ImageView)
        self.view.addSubview(userNameLabel)
        self.view.addSubview(TableView)
    }
    
    func iPhoneXsetUI() {
        
    }
    
    func onlineBattle() {
        let dict = ["firstLaunch": true]
        userDefault.register(defaults: dict)
        
        if userDefault.bool(forKey: "firstLaunch") {
            let target = newViewController()
            self.present( target, animated: true, completion: nil)
            return
        }else {
            let user = Auth.auth().currentUser
            
            userNameLabel.text = user?.displayName
            
            button1.layer.borderWidth = 1
            button1.layer.cornerRadius = 5
            
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
                        
                        //自分のデータのinRoomに対戦中であることを書く
                        self.ref.child("users").child((user?.uid)!).updateChildValues(["inRoom": "true"])
                        
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
        
        switch indexPath.row {
        case 0:
            print("フィードバック")
            self.Feedback()
        case 1:
            print("対戦成績")
            self.対戦成績()
        case 2:
            print("ログアウト")
            self.signOut()
        default:
            print("当てはまらない")
        }
    }
    
    func Feedback() {
        performSegue(withIdentifier: "toFeedbackViewController", sender: nil)
    }
    
    func 対戦成績() {
        
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        let userName = user?.displayName
        
        self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let Win_count = String(describing: snapshot.childSnapshot(forPath: "Win_count").value!)
            let Defeat_count = String(describing: snapshot.childSnapshot(forPath: "Defeat_count").value!)
            
            // アラートを作成
            let Alert = UIAlertController(
                title: "対戦成績",
                message: Win_count + "勝" + Defeat_count + "敗",
                preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style:UIAlertActionStyle.default){
                (action: UIAlertAction) in
            }
            
            let tweet = UIAlertAction(title: "ツイート", style: UIAlertActionStyle.default){
                (action: UIAlertAction) in
                
                //iosバージョンを取得
                let iosVersion = UIDevice.current.systemVersion
                if (iosVersion >= "11.0") {
                    //ios11の処理
                    print("ios11")
                    let composer = TWTRComposer()
                    composer.setText("\(userName ?? "noName")は現在\n\(Win_count)勝\(Defeat_count)敗\n#ButtonChecker ")
                    composer.show(from: self) { result in
                    }
                    
                }else{
                    print("ios11未満")
                    var myComposeView : SLComposeViewController!//Twitter
                    //ios11以下の処理
                    myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    // 投稿するテキストを指定.
                    myComposeView.setInitialText("\(userName ?? "noName")は現在\n\(Win_count)勝\(Defeat_count)敗\n#ButtonChecker ")
                    // myComposeViewの画面遷移.
                    self.present(myComposeView, animated: true, completion: nil)
                }
            }
            
            let login = UIAlertAction(title: "Twitterアカウント追加", style: UIAlertActionStyle.default){
                (action: UIAlertAction) in
                
                TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
                    if (session != nil) {
                        print("ok")
                    } else {
                        print("error")
                    }
                })
            }
            
            //部品をアラートコントローラーに追加していく
            Alert.addAction(OK)
            Alert.addAction(tweet)
            Alert.addAction(login)
            
            //アラートを表示
            self.present(Alert,animated: true, completion: nil)
        })
    }
    
    //サインアウトのメソッド
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            //ログイン中
            let user = Auth.auth().currentUser
            ref = Database.database().reference()
            
            self.ref.child("users").child(user!.uid).updateChildValues(["App":0])
            
            try firebaseAuth.signOut()
            print("サインアウト出来ました")
            
            //サインアウトと同時にユーザーデフォルトに入っている画像データを削除する
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
        }))
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    //画面を開いたとき
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dict = ["firstLaunch": true]
        userDefault.register(defaults: dict)
        if userDefault.bool(forKey: "firstLaunch") {
            return
        }else {
            
            let user = Auth.auth().currentUser
            let uid = user?.uid
            
            if (UserDefaults.standard.object(forKey: "MyPhoto") != nil) {
                print("データ有り")
                let imageDate:NSData = UserDefaults.standard.object(forKey: "MyPhoto") as! NSData
                ImageView.image = UIImage(data:imageDate as Data)
            }else {
                print("データ無し")
                //ここに画像を入れる
                ImageView.image = #imageLiteral(resourceName: "account.png")
                
                let num = Int(arc4random_uniform(9))
                
                //画像データがない時10%の確率でアラートを表示する
                if num == 0 {
                    self.Alert()
                }
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
                        print("エラーの内容は...\(error)")
                        self.Alert()
                    } else {
                        // Data for "images/island.jpg" is returned
                        self.ImageView.image = UIImage(data: data!)
                        self.self.userDefault.set(UIImagePNGRepresentation(self.ImageView.image!), forKey: "MyPhoto")
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
