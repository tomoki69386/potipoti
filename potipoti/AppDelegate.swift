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
 import TwitterKit
 import TwitterCore
 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
    var ref:DatabaseReference!
    var isCreate = true //データの作成か更新かを判定、trueなら作成、falseなら更新
    var myNavigationController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        TWTRTwitter.sharedInstance().start(withConsumerKey: "GpKnAYPhoFU8Y4WLZ4mZh62wd", consumerSecret: "a69vNIamfqKdzqW4I1GoCaYFMW5Htl7KDn58HklGPOZiuLykz9")
        
        //ナビゲーションコントローラーの設定
        let firstNavigation: ViewController = ViewController()
        myNavigationController = UINavigationController(rootViewController: firstNavigation)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = myNavigationController
        self.window?.makeKeyAndVisible()
        
        
        // ページを格納する配列
        var viewControllers: [UIViewController] = []
        
        // 1ページ目になるViewController
        let firstVC = TopViewController()
        firstVC.tabBarItem = UITabBarItem(title: "HOME", image: #imageLiteral(resourceName: "home.png"), tag: 1)
        viewControllers.append(firstVC)
        
        // 2ページ目になるViewController
        let secondVC = ProfileViewController()
        secondVC.tabBarItem = UITabBarItem(title: "account", image: #imageLiteral(resourceName: "account.png"), tag: 2)
        viewControllers.append(secondVC)
        
        // ページをセット
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: false)
        
        // ルートを UITabBarController にする
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options) {
            return true
        }
        return false
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
