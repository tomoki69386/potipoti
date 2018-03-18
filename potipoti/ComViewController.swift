//
//  ComViewController.swift
//  黒ひげ
//
//  Created by 築山朋紀 on 2017/04/11.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import TwitterKit
import Social

class ComViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    var defaults: UserDefaults = UserDefaults.standard
    var number: Int = 0
    var count: Int = 19
    
    @IBOutlet var button0: UIButton!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    @IBOutlet var button10: UIButton!
    @IBOutlet var button11: UIButton!
    @IBOutlet var button12: UIButton!
    @IBOutlet var button13: UIButton!
    @IBOutlet var button14: UIButton!
    @IBOutlet var button15: UIButton!
    @IBOutlet var button16: UIButton!
    @IBOutlet var button17: UIButton!
    @IBOutlet var button18: UIButton!
    @IBOutlet var button19: UIButton!
    
    //音楽再生
    var seikaiplayer:AVAudioPlayer!
    var hazureplayer:AVAudioPlayer!
    let seikaiurl = Bundle.main.bundleURL.appendingPathComponent("正解.mp3")
    let hazureurl = Bundle.main.bundleURL.appendingPathComponent("ハズレ.mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try seikaiplayer = AVAudioPlayer(contentsOf:seikaiurl)
            //音楽をバッファに読み込んでおく
            seikaiplayer.prepareToPlay()
        } catch {
            print(error)
        }
        
        do {
            try hazureplayer = AVAudioPlayer(contentsOf:hazureurl)
            //音楽をバッファに読み込んでおく
            hazureplayer.prepareToPlay()
        } catch {
            print(error)
        }
        //0~19までのランダムな数字を発生させる
        number = Int(arc4random_uniform(20))
        
        print("ハズレのButtonは..\(number)")
        
        defaults.set(number, forKey: "hoge")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //Buttonを押した時の処理
    @IBAction func Button(sender: UIButton) {
        let j = defaults.integer(forKey: "hoge")
        if j == sender.tag {
            self.hazure()
        }else {
            self.atari()
        }
        //Buttonの削除する処理を書く
        switch sender.tag {
        case 0:
            button0.isHidden = true
        case 1:
            button1.isHidden = true
        case 2:
            button2.isHidden = true
        case 3:
            button3.isHidden = true
        case 4:
            button4.isHidden = true
        case 5:
            button5.isHidden = true
        case 6:
            button6.isHidden = true
        case 7:
            button7.isHidden = true
        case 8:
            button8.isHidden = true
        case 9:
            button9.isHidden = true
        case 10:
            button10.isHidden = true
        case 11:
            button11.isHidden = true
        case 12:
            button12.isHidden = true
        case 13:
            button13.isHidden = true
        case 14:
            button14.isHidden = true
        case 15:
            button15.isHidden = true
        case 16:
            button16.isHidden = true
        case 17:
            button17.isHidden = true
        case 18:
            button18.isHidden = true
        case 19:
            button19.isHidden = true
        default:
            print("error")
        }
        self.owari()
    }
    
    func hazure() {
        label.text = ("ハズレ")
        //バイブレーション
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        hazureplayer.play()
        // アラートを作成
        let alert = UIAlertController(
            title: "負けました",
            message: "終了",
            preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "OK", style:UIAlertActionStyle.default){
            (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(OK)
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func atari() {
        label.text = ("セーフ")
        seikaiplayer.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.label.text = ("")
        }
    }
    
    func owari() {
        count -= 1
        print("残りのボタンは...\(count)個")
        if count == 0 {
            // アラートを作成
            let alert = UIAlertController(
                title: "勝ちました",
                message: "終了",
                preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "OK", style:UIAlertActionStyle.default){
                (action: UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            
            let tweet = UIAlertAction(title: "ツイート", style: UIAlertActionStyle.default){
                (action: UIAlertAction) in
                
                //コンテキスト開始
                UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0.0)
                //viewを書き出す
                self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
                // imageにコンテキストの内容を書き出す
                let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                //コンテキストを閉じる
                UIGraphicsEndImageContext()
                
                print("ios11")
                let composer = TWTRComposer()
                composer.setText("シングルプレイで勝ちました！\n#ButtonChecker ")
                composer.setImage(image)
                composer.show(from: self) { result in
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
            
            alert.addAction(OK)
            alert.addAction(tweet)
            alert.addAction(login)
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
    }
}
