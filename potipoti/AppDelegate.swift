 //
 //  AppDelegate.swift
 //  potipoti
 //
 //  Created by 築山朋紀 on 2017/07/17.
 //  Copyright © 2017年 築山朋紀. All rights reserved.
 //
 //　Firebase　https://console.firebase.google.com/project/potipoti-e1d0e/database/data?hl=ja
 //
 // Appが0ならオフライン中、１ならオンライン中
 //
 
 import UIKit
 import Firebase
 import FirebaseDatabase
 import FirebaseAuth
 import SVProgressHUD
 import AVFoundation
 import AudioToolbox
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
    var ref:DatabaseReference!
    var isCreate = true //データの作成か更新かを判定、trueなら作成、falseなら更新
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
 
    func applicationDidFinishLaunching(_ application: UIApplication) {
        FirebaseApp.configure()
    }
    
    //アプリを閉じた時に呼ばれるメソッド
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("アプリを閉じた時に呼ばれる")
        
        //ログインしてたらAppを0にする(アプリを閉じていてる時)
        if let _ = Auth.auth().currentUser {
            //ログイン中
            let user = Auth.auth().currentUser
            ref = Database.database().reference()
            
            self.ref.child("users").child(user!.uid).updateChildValues(["App":0])
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("フリックしてアプリを終了させた時に呼ばれる")
        
        //ログインしてたらAppを0にする(アプリを閉じている時)
        if let _ = Auth.auth().currentUser {
            //ログイン中
            let user = Auth.auth().currentUser
            ref = Database.database().reference()
            
            self.ref.child("users").child(user!.uid).updateChildValues(["App":0])
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("アプリを開いた時に呼ばれる")
        
        if let _ = Auth.auth().currentUser {
            //ログイン中
            let user = Auth.auth().currentUser
            ref = Database.database().reference()
            
            self.ref.child("users").child(user!.uid).updateChildValues(["App":1])
        }
    }
 }
