//
//  TopViewController.swift
//  黒ひげ
//
//  Created by 築山朋紀 on 2017/04/11.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD
import AVFoundation
import AudioToolbox

class TopViewController: UIViewController {
    
    let Label = UILabel()
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    
    var ref: DatabaseReference!
    //trueならアラートを表示中、falseならアラートを表示していない
    var Existence: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
        self.title = "Home"
    
    }
    
    //UIの設定
    func setUpUI() {
        
        hidesBottomBarWhenPushed = true
        
        let tabBarController: UITabBarController = UITabBarController()
        let tabBarHeight = tabBarController.tabBar.frame.size.height
        let navigationController: UINavigationController = UINavigationController()
        let navigationBarHeight = navigationController.navigationBar.frame.size.height
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        //スクリーンサイズ
        let screenWidth: CGFloat = self.view.frame.width
        let screenHeight: CGFloat = self.view.frame.height - tabBarHeight
        
        //ボタンのサイズ
        let buttonSize = screenWidth / 5
        
        //ボタンの間の間隔
        let spaceSize = screenWidth / 6
        
        //位置の設定
        Label.frame = CGRect(x: 0, y: navigationBarHeight + statusbarHeight, width: screenWidth, height: (screenHeight - spaceSize * 3 - buttonSize * 3) - (navigationBarHeight + statusbarHeight))
        button1.frame = CGRect(x: buttonSize, y: screenHeight - spaceSize * 3 - buttonSize * 3, width: buttonSize * 3, height: buttonSize)
        button2.frame = CGRect(x: buttonSize, y: screenHeight - spaceSize * 2 - buttonSize * 2, width: buttonSize * 3, height: buttonSize)
        button3.frame = CGRect(x: buttonSize, y: screenHeight - spaceSize - buttonSize, width: buttonSize * 3, height: buttonSize)
        
        //テキスト設定
        Label.text = "Button Checker"
        button1.setTitle("友達とプレイ", for: UIControlState.normal)
        button2.setTitle("1人でプレイ", for: UIControlState.normal)
        button3.setTitle("オンライン対戦", for: UIControlState.normal)
        
        //文字のカラー
        Label.textColor = UIColor.black
        button1.setTitleColor(UIColor.black, for: .normal)
        button2.setTitleColor(UIColor.black, for: .normal)
        button3.setTitleColor(UIColor.black, for: .normal)
        
        //背景カラー
        button1.backgroundColor = UIColor(hex: "FEF978")
        button2.backgroundColor = UIColor(hex: "FEF978")
        button3.backgroundColor = UIColor(hex: "FEF978")
        
        //フォントサイズ
        Label.font = UIFont.systemFont(ofSize: 20)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        //枠丸にする
        button1.layer.cornerRadius = buttonSize / 2
        button2.layer.cornerRadius = buttonSize / 2
        button3.layer.cornerRadius = buttonSize / 2
        
        Label.textAlignment = NSTextAlignment.center
        
        //ボタンをタップしたときの処理を与える
        button1.addTarget(self, action: #selector(TopViewController.toViewCountroller(sender:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(TopViewController.toSingleyViewCountroller(sender:)), for: .touchUpInside)
        button3.addTarget(self, action: #selector(TopViewController.toPlayerViewCountroller(sender:)), for: .touchUpInside)
        
        //Viewに追加する
        self.view.addSubview(Label)
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
    }
    
    //友達でプレイ画面に遷移する
    @objc func toViewCountroller(sender: UIButton) {
        //画面遷移
        let target = ViewController()
        self.navigationController?.pushViewController(target, animated: true)
    }
    
    //シングルプレイ画面に遷移する
    @objc func toSingleyViewCountroller(sender: UIButton) {
        //画面遷移
        let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "SingleyViewController" ) as! SingleyViewController
        self.present( targetViewController, animated: true, completion: nil)
    }
    
    //オンライン対戦画面に遷移する
    @objc func toPlayerViewCountroller(sender: UIButton) {
        
        if let _ = Auth.auth().currentUser {
            //ログインしている
            //オンラインプレイヤー画面に遷移する
            let target = PlayerViewController()
            self.navigationController?.pushViewController(target, animated: true)
        }else {
            //ログインしていない
            //アカウント作成画面に移動する
            let targetViewController = self.storyboard!.instantiateViewController(withIdentifier: "newViewController") as! newViewController
            self.present(targetViewController, animated: true, completion: nil)
        }
    }
    
    func onlineBattle() {
        ref = Database.database().reference()
        
        if let _ = Auth.auth().currentUser {
            //ログイン中
            let user = Auth.auth().currentUser
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
            return
        }else {
            //ログインしてない
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
