//
//  FeedbackViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2018/03/16.
//  Copyright © 2018年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD
import AVFoundation
import AudioToolbox

class FeedbackViewController: UIViewController {
    
    var ref: DatabaseReference! //Firebase
    let user = Auth.auth().currentUser
    
    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //フォーカスの設定
        textView.becomeFirstResponder()
    }
    
    @IBAction func post() {
        ref = Database.database().reference()
        let userName = user?.displayName
        self.ref.child("Feedback").childByAutoId().setValue([userName! + ": Feedback":textView.text])
        
        let alert = UIAlertController(
            title: "フィードバックありがとうございます！",
            message: "送信完了",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "戻る", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)
        }))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
