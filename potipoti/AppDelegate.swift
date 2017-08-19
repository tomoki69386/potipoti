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
            let uid = user?.uid
            let name = user?.displayName
            ref = Database.database().reference()
            
            self.ref.child("Active_users").child(user!.uid).setValue(["username": name, "uid": uid])
        
            let storyboard:UIStoryboard =  UIStoryboard(name: "Main",bundle:nil)
            window?.rootViewController
                = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        }
        
        return true
    }
    
    //アプリを閉じた時に呼ばれるメソッド
    func applicationDidEnterBackground(application: UIApplication) {
        print("アプリを閉じた時に呼ばれる")
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

