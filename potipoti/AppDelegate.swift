 //
 //  AppDelegate.swift
 //  potipoti
 //
 //  Created by 築山朋紀 on 2017/07/17.
 //  Copyright © 2017年 築山朋紀. All rights reserved.
 //
 
 import UIKit
 import Firebase
 import FirebaseAuth
 import SVProgressHUD
 import JSQMessagesViewController
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var ref:DatabaseReference!
    var isCreate = true //データの作成か更新かを判定、trueなら作成、falseなら更新
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // ここに初期化処理を書く
        // UserDefaultsを使ってフラグを保持する
        let userDefault = UserDefaults.standard
        // "firstLaunch"をキーに、Bool型の値を保持する
        let dict = ["firstLaunch": true]
        // デフォルト値登録
        // ※すでに値が更新されていた場合は、更新後の値のままになる
        userDefault.register(defaults: dict)
        
        // "firstLaunch"に紐づく値がtrueなら(=初回起動)、値をfalseに更新して処理を行う
        if userDefault.bool(forKey: "firstLaunch") {
            //            userDefault.set(false, forKey: "firstLaunch")
            print("初回起動時だけ処理")
            let storyboard:UIStoryboard =  UIStoryboard(name: "Main",bundle:nil)
            window?.rootViewController
                = storyboard.instantiateViewController(withIdentifier: "newViewController")
        }
        print("毎回処理する")
        
        //ログインしてたら、画面遷移
        if let _ = Auth.auth().currentUser {
            //ログイン中
            let user = Auth.auth().currentUser
            let name = user?.displayName //ユーザーの名前の定数
            ref = Database.database().reference()
            
            self.ref.child("users").child(user!.uid).setValue(["username": name,"uid": user?.uid,"inRoom": "false", "inApp": "true"])
            
            let storyboard:UIStoryboard =  UIStoryboard(name: "Main",bundle:nil)
            window?.rootViewController
                = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        }
        
        return true
    }
    
    //アプリを閉じた時に呼ばれるメソッド
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("アプリを閉じた時に呼ばれる")
        
        //ログインしてたらinRoomをfalseにする、inAppをfalseにする
        if let _ = Auth.auth().currentUser {
            //ログイン中
            let user = Auth.auth().currentUser
            ref = Database.database().reference()
            
            self.ref.child("users").child(user!.uid).updateChildValues(["inRoom": "false", "inApp": "false"])
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("フリックしてアプリを終了させた時に呼ばれる")
        
        //ログインしてたらinRoomをfalseにする、inAppをfalseにする
        if let _ = Auth.auth().currentUser {
            //ログイン中
            let user = Auth.auth().currentUser
            ref = Database.database().reference()
            
            self.ref.child("users").child(user!.uid).updateChildValues(["inRoom": "false", "inApp": "false"])
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("アプリを開いた時に呼ばれる")
        
        //ログインしてたらinRoomをfalseにする、inAppをtrueにする
        if let _ = Auth.auth().currentUser {
            //ログイン中
            let user = Auth.auth().currentUser
            ref = Database.database().reference()
            
            self.ref.child("users").child(user!.uid).updateChildValues(["inRoom": "false", "inApp": "true"])
        }
    }
 }
