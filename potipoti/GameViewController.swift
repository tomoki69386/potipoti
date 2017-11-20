//
//  GameViewController.swift
//  黒ひげ
//
//  Created by 築山朋紀 on 2017/04/08.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class GameViewController: UIViewController {
    
    var ninzuu4Array : [String] = ["", "", "",""]
    var ninzuu3Array : [String] = ["", "", ""]
    var ninzuu2Array : [String] = ["",""]
    var ransu: Int = 0
    var darenumber: Int = 0
    
    var index: Int = 0
    @IBOutlet var darelabel: UILabel!
    
    var number: Int = 0
    var defaults: UserDefaults = UserDefaults.standard
    @IBOutlet var label: UILabel!
    var count: Int = 19
    var ninzuu: Int = 0
    
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
        
        ninzuu = defaults.integer(forKey: "ninzuu")
        print("プレイヤーの人数は...\(ninzuu)人")
        
        if ninzuu == 4 {
            
            let Player4 = String(defaults.string(forKey: "Player4")!)
            let Player3 = String(defaults.string(forKey: "Player3")!)
            let Player2 = String(defaults.string(forKey: "Player2")!)
            let Player1 = String(defaults.string(forKey: "Player1")!)
            
            ninzuu4Array[3] = Player4!
            ninzuu4Array[2] = Player3!
            ninzuu4Array[1] = Player2!
            ninzuu4Array[0] = Player1!
            
            darenumber = Int(arc4random_uniform(4))
            
            if darenumber > 2 {
                index = 3
            }else if darenumber > 1 {
                index = 2
            }else if darenumber > 0 {
                index = 1
            }else {
                index = 0
            }
            
            darelabel.text = ninzuu3Array[index]
            
        }else if ninzuu == 3 {
            
            let Player3 = String(defaults.string(forKey: "Player3")!)
            let Player2 = String(defaults.string(forKey: "Player2")!)
            let Player1 = String(defaults.string(forKey: "Player1")!)
            
            ninzuu3Array[2] = Player3!
            ninzuu3Array[1] = Player2!
            ninzuu3Array[0] = Player1!
            
            darenumber = Int(arc4random_uniform(3))
            
            if darenumber > 1 {
                index = 2
            }else if darenumber > 0 {
                index = 1
                
            }else {
                index = 0
            }
            darelabel.text = ninzuu3Array[index]
            
        }else if ninzuu == 2 {
            
            let Player2 = String(defaults.string(forKey: "Player2")!)
            let Player1 = String(defaults.string(forKey: "Player1")!)
            
            ninzuu2Array[1] = Player2!
            ninzuu2Array[0] = Player1!
            
            darenumber = Int(arc4random_uniform(2))
            if darenumber > 0 {
                index = 1
            }else {
                index = 0
            }
            darelabel.text = ninzuu2Array[index]
        }
        
        //0~19までのランダムな数字を発生させる
        number = Int(arc4random_uniform(20))
        
        defaults.set(number, forKey: "aaa")
        print("ハズレのButtonは...\(number)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Button(sender: UIButton){
        let j = defaults.integer(forKey: "aaa")
        if j == sender.tag {
            self.arato()
        }else {
            self.safe()
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
            count -= 1
            print(count)
            if count == 0 {
                self.kati()
            }
        }
        self.dare()
    }
    
    
    //セーフの時に処理するメソッド
    func safe() {
        label.text = "セーフ!!"
        seikaiplayer.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.label.text = ("")
        }
        
    }
    
    //ハズレの時に処理するメソッド
    func arato() {
        label.text = ("ハズレ")
        //バイブレーション
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        hazureplayer.play()
        // アラートを作成
        let alert = UIAlertController(
            title: "負けました",
            message: "終了",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)
        }))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func kati() {
        // アラートを作成
        let alert = UIAlertController(
            title: "勝ちました",
            message: "終了",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)
        }))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func dare() {
        
        if ninzuu == 4 {
            darelabel.text = ninzuu4Array[index]
            ransu = Int(arc4random_uniform(4))
            if ransu > 2 {
                index = 3
                
            }else if ransu > 1 {
                index = 2
                
            }else if ransu > 0 {
                index = 1
                
            }else {
                index = 0
            }
            
        }else if ninzuu == 3 {
            darelabel.text = ninzuu3Array[index]
            ransu = Int(arc4random_uniform(3))
            if ransu > 1 {
                index = 2
                
            }else if ransu > 0 {
                index = 1
                
            }else {
                index = 0
            }
            
        }else if ninzuu == 2 {
            darelabel.text = ninzuu2Array[index]
            ransu = Int(arc4random_uniform(2))
            if ransu > 0 {
                index = 1
                
            }else {
                index = 0
            }
        }
    }
}
