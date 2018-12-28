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
    
    var menberNameArrey: [String] = []
    let userDefaults = UserDefaults.standard
    
    //デフォルトで0に設定しておく
    var outButtonNumber: Int = 0
    
    let Button_0 = UIButton()
    let Button_1 = UIButton()
    let Button_2 = UIButton()
    let Button_3 = UIButton()
    let Button_4 = UIButton()
    let Button_5 = UIButton()
    let Button_6 = UIButton()
    let Button_7 = UIButton()
    let Button_8 = UIButton()
    let Button_9 = UIButton()
    let Button_10 = UIButton()
    let Button_11 = UIButton()
    let Button_12 = UIButton()
    let Button_13 = UIButton()
    let Button_14 = UIButton()
    let Button_15 = UIButton()
    let Button_16 = UIButton()
    let Button_17 = UIButton()
    let Button_18 = UIButton()
    let Button_19 = UIButton()
    
    let label = UILabel()
    let darelabel = UILabel()
    
    //音楽再生
    var seikaiplayer:AVAudioPlayer!
    var hazureplayer:AVAudioPlayer!
    let seikaiurl = Bundle.main.bundleURL.appendingPathComponent("正解.mp3")
    let hazureurl = Bundle.main.bundleURL.appendingPathComponent("ハズレ.mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //参加者の名前を配列に追加する
        menberNameArrey = userDefaults.array(forKey: "memberName") as! [String]
        
        //UIの設定
        setUpUI()
        nextMember()
        
        //outButtonNumberの設定
        outButtonNumber = setUpRandom(number: 20)
        print("ハズレのButtonは...\(outButtonNumber)")
        
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
    }
    
    @objc func tap(sender: UIButton){
        
        //Buttonの削除する処理を書く
        removeButton(buttonNumber: sender.tag)
        
        if outButtonNumber == sender.tag {
            //outButtonを押してしまったときの処理
            label.text = "ハズレ"
            //バイブレーション
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            hazureplayer.play()
            
            let name = userDefaults.string(forKey: "name")
            
            //アラートの設定
            let alert = UIAlertController (title: "\(name ?? "")さんの負け", message: "終了", preferredStyle: .alert)
            
            //アラートにButtonを付ける
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                //Buttonを押したときの処理
                self.dismiss(animated: true, completion: nil)
                self.userDefaults.removeObject(forKey: "memberName")
            }))
            
            //アラートに表示
            self.present(alert, animated: true, completion: nil)
            
        }else {
            //セーフだった場合の処理
            //次にButtonを押せる人を設定する
            nextMember()
            label.text = "セーフ！！"
            
            //SE再生
            seikaiplayer.play()
            
            //1.5秒後にLabelのテキストを削除する
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.label.text = ""
            }
        }
    }
    
    func nextMember() {
        let index = setUpRandom(number: menberNameArrey.count)
        darelabel.text = "次は\(menberNameArrey[index])さんの番"
        userDefaults.set(menberNameArrey[index], forKey: "name")
    }
    
    //ランダムな数字を吐く
    func setUpRandom(number: Int) -> Int {
        let random = Int(arc4random_uniform(UInt32(number)))
        
        return random
    }
    
    func removeButton(buttonNumber: Int) {
        switch buttonNumber {
        case 0:
            Button_0.isHidden = true
        case 1:
            Button_1.isHidden = true
        case 2:
            Button_2.isHidden = true
        case 3:
            Button_3.isHidden = true
        case 4:
            Button_4.isHidden = true
        case 5:
            Button_5.isHidden = true
        case 6:
            Button_6.isHidden = true
        case 7:
            Button_7.isHidden = true
        case 8:
            Button_8.isHidden = true
        case 9:
            Button_9.isHidden = true
        case 10:
            Button_10.isHidden = true
        case 11:
            Button_11.isHidden = true
        case 12:
            Button_12.isHidden = true
        case 13:
            Button_13.isHidden = true
        case 14:
            Button_14.isHidden = true
        case 15:
            Button_15.isHidden = true
        case 16:
            Button_16.isHidden = true
        case 17:
            Button_17.isHidden = true
        case 18:
            Button_18.isHidden = true
        case 19:
            Button_19.isHidden = true
        default:
            print("error")
        }
    }
    
    func setUpUI() {
        let screenWidth: CGFloat = self.view.frame.width
        let screenHeight: CGFloat = self.view.frame.height
        
        //ボタンのサイズ
        let buttonSize = screenWidth / 4
        
        label.frame = CGRect(x: 0, y: screenHeight - buttonSize * 6.5, width: screenWidth, height: buttonSize)
        label.text = "判定"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        
        darelabel.frame = CGRect(x: 0, y: screenHeight - buttonSize * 6 + buttonSize / 3, width: screenWidth, height: buttonSize - buttonSize / 3)
        darelabel.text = "次は　　さんの番"
        darelabel.textColor = UIColor.black
        darelabel.font = UIFont.systemFont(ofSize:25)
        darelabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(darelabel)
        
        //ボタンの位置
        Button_0.frame = CGRect(x: 0, y: screenHeight - buttonSize * 5, width: buttonSize, height: buttonSize)
        Button_1.frame = CGRect(x: screenWidth / 4, y: screenHeight - buttonSize * 5, width: buttonSize, height: buttonSize)
        Button_2.frame = CGRect(x: screenWidth / 4 * 2, y: screenHeight - buttonSize * 5, width: buttonSize, height: buttonSize)
        Button_3.frame = CGRect(x: screenWidth / 4 * 3, y: screenHeight - buttonSize * 5, width: buttonSize, height: buttonSize)
        
        Button_4.frame = CGRect(x: 0, y: screenHeight - buttonSize * 4, width: buttonSize, height: buttonSize)
        Button_5.frame = CGRect(x: screenWidth / 4, y: screenHeight - buttonSize * 4, width: buttonSize, height: buttonSize)
        Button_6.frame = CGRect(x: screenWidth / 4 * 2, y: screenHeight - buttonSize * 4, width: buttonSize, height: buttonSize)
        Button_7.frame = CGRect(x: screenWidth / 4 * 3, y: screenHeight - buttonSize * 4, width: buttonSize, height: buttonSize)
        
        Button_8.frame = CGRect(x: 0, y: screenHeight - buttonSize * 3, width: buttonSize, height: buttonSize)
        Button_9.frame = CGRect(x: screenWidth / 4, y: screenHeight - buttonSize * 3, width: buttonSize, height: buttonSize)
        Button_10.frame = CGRect(x: screenWidth / 4 * 2, y: screenHeight - buttonSize * 3, width: buttonSize, height: buttonSize)
        Button_11.frame = CGRect(x: screenWidth / 4 * 3, y: screenHeight - buttonSize * 3, width: buttonSize, height: buttonSize)
        
        Button_12.frame = CGRect(x: 0, y: screenHeight - buttonSize * 2, width: buttonSize, height: buttonSize)
        Button_13.frame = CGRect(x: screenWidth / 4, y: screenHeight - buttonSize * 2, width: buttonSize, height: buttonSize)
        Button_14.frame = CGRect(x: screenWidth / 4 * 2, y: screenHeight - buttonSize * 2, width: buttonSize, height: buttonSize)
        Button_15.frame = CGRect(x: screenWidth / 4 * 3, y: screenHeight - buttonSize * 2, width: buttonSize, height: buttonSize)
        
        Button_16.frame = CGRect(x: 0, y: screenHeight - buttonSize, width: buttonSize, height: buttonSize)
        Button_17.frame = CGRect(x: screenWidth / 4, y: screenHeight - buttonSize, width: buttonSize, height: buttonSize)
        Button_18.frame = CGRect(x: screenWidth / 4 * 2, y: screenHeight - buttonSize, width: buttonSize, height: buttonSize)
        Button_19.frame = CGRect(x: screenWidth / 4 * 3, y: screenHeight - buttonSize, width: buttonSize, height: buttonSize)
        
        //ボタンのタイトル
        Button_0.setTitle("0", for: UIControlState.normal)
        Button_1.setTitle("1", for: UIControlState.normal)
        Button_2.setTitle("2", for: UIControlState.normal)
        Button_3.setTitle("3", for: UIControlState.normal)
        Button_4.setTitle("4", for: UIControlState.normal)
        Button_5.setTitle("5", for: UIControlState.normal)
        Button_6.setTitle("6", for: UIControlState.normal)
        Button_7.setTitle("7", for: UIControlState.normal)
        Button_8.setTitle("8", for: UIControlState.normal)
        Button_9.setTitle("9", for: UIControlState.normal)
        Button_10.setTitle("10", for: UIControlState.normal)
        Button_11.setTitle("11", for: UIControlState.normal)
        Button_12.setTitle("12", for: UIControlState.normal)
        Button_13.setTitle("13", for: UIControlState.normal)
        Button_14.setTitle("14", for: UIControlState.normal)
        Button_15.setTitle("15", for: UIControlState.normal)
        Button_16.setTitle("16", for: UIControlState.normal)
        Button_17.setTitle("17", for: UIControlState.normal)
        Button_18.setTitle("18", for: UIControlState.normal)
        Button_19.setTitle("19", for: UIControlState.normal)
        
        //ボタンのタイトルカラー
        Button_0.setTitleColor(UIColor.white, for: .normal)
        Button_1.setTitleColor(UIColor.white, for: .normal)
        Button_2.setTitleColor(UIColor.white, for: .normal)
        Button_3.setTitleColor(UIColor.white, for: .normal)
        Button_4.setTitleColor(UIColor.white, for: .normal)
        Button_5.setTitleColor(UIColor.white, for: .normal)
        Button_6.setTitleColor(UIColor.white, for: .normal)
        Button_7.setTitleColor(UIColor.white, for: .normal)
        Button_8.setTitleColor(UIColor.white, for: .normal)
        Button_9.setTitleColor(UIColor.white, for: .normal)
        Button_10.setTitleColor(UIColor.white, for: .normal)
        Button_11.setTitleColor(UIColor.white, for: .normal)
        Button_12.setTitleColor(UIColor.white, for: .normal)
        Button_13.setTitleColor(UIColor.white, for: .normal)
        Button_14.setTitleColor(UIColor.white, for: .normal)
        Button_15.setTitleColor(UIColor.white, for: .normal)
        Button_16.setTitleColor(UIColor.white, for: .normal)
        Button_17.setTitleColor(UIColor.white, for: .normal)
        Button_18.setTitleColor(UIColor.white, for: .normal)
        Button_19.setTitleColor(UIColor.white, for: .normal)
        
        //ボタンのフォントサイズ
        Button_0.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_1.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_2.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_3.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_4.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_5.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_6.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_7.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_8.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_9.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_10.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_11.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_12.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_13.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_14.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_15.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_16.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_17.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_18.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        Button_19.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        //ボタンの背景色
        Button_0.backgroundColor = UIColor(hex: "468401")
        Button_1.backgroundColor = UIColor(hex: "468401")
        Button_2.backgroundColor = UIColor(hex: "468401")
        Button_3.backgroundColor = UIColor(hex: "468401")
        Button_4.backgroundColor = UIColor(hex: "468401")
        Button_5.backgroundColor = UIColor(hex: "468401")
        Button_6.backgroundColor = UIColor(hex: "468401")
        Button_7.backgroundColor = UIColor(hex: "468401")
        Button_8.backgroundColor = UIColor(hex: "468401")
        Button_9.backgroundColor = UIColor(hex: "468401")
        Button_10.backgroundColor = UIColor(hex: "468401")
        Button_11.backgroundColor = UIColor(hex: "468401")
        Button_12.backgroundColor = UIColor(hex: "468401")
        Button_13.backgroundColor = UIColor(hex: "468401")
        Button_14.backgroundColor = UIColor(hex: "468401")
        Button_15.backgroundColor = UIColor(hex: "468401")
        Button_16.backgroundColor = UIColor(hex: "468401")
        Button_17.backgroundColor = UIColor(hex: "468401")
        Button_18.backgroundColor = UIColor(hex: "468401")
        Button_19.backgroundColor = UIColor(hex: "468401")
        
        //ボタンをタップしたときの処理
        Button_0.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_1.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_2.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_3.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_4.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_5.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_6.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_7.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_8.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_9.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_10.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_11.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_12.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_13.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_14.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_15.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_16.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_17.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_18.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        Button_19.addTarget(self, action: #selector(GameViewController.tap(sender:)), for: .touchUpInside)
        
        //ボタンにタグを設定する
        Button_0.tag = 0
        Button_1.tag = 1
        Button_2.tag = 2
        Button_3.tag = 3
        Button_4.tag = 4
        Button_5.tag = 5
        Button_6.tag = 6
        Button_7.tag = 7
        Button_8.tag = 8
        Button_9.tag = 9
        Button_10.tag = 10
        Button_11.tag = 11
        Button_12.tag = 12
        Button_13.tag = 13
        Button_14.tag = 14
        Button_15.tag = 15
        Button_16.tag = 16
        Button_17.tag = 17
        Button_18.tag = 18
        Button_19.tag = 19
        
        //ボタンの枠のカラー
        Button_0.layer.borderColor = UIColor.white.cgColor
        Button_1.layer.borderColor = UIColor.white.cgColor
        Button_2.layer.borderColor = UIColor.white.cgColor
        Button_3.layer.borderColor = UIColor.white.cgColor
        Button_4.layer.borderColor = UIColor.white.cgColor
        Button_5.layer.borderColor = UIColor.white.cgColor
        Button_6.layer.borderColor = UIColor.white.cgColor
        Button_7.layer.borderColor = UIColor.white.cgColor
        Button_8.layer.borderColor = UIColor.white.cgColor
        Button_9.layer.borderColor = UIColor.white.cgColor
        Button_10.layer.borderColor = UIColor.white.cgColor
        Button_11.layer.borderColor = UIColor.white.cgColor
        Button_12.layer.borderColor = UIColor.white.cgColor
        Button_13.layer.borderColor = UIColor.white.cgColor
        Button_14.layer.borderColor = UIColor.white.cgColor
        Button_15.layer.borderColor = UIColor.white.cgColor
        Button_16.layer.borderColor = UIColor.white.cgColor
        Button_17.layer.borderColor = UIColor.white.cgColor
        Button_18.layer.borderColor = UIColor.white.cgColor
        Button_19.layer.borderColor = UIColor.white.cgColor
        
        //ボタンの枠の幅
        Button_0.layer.borderWidth = 1.0
        Button_1.layer.borderWidth = 1.0
        Button_2.layer.borderWidth = 1.0
        Button_3.layer.borderWidth = 1.0
        Button_4.layer.borderWidth = 1.0
        Button_5.layer.borderWidth = 1.0
        Button_6.layer.borderWidth = 1.0
        Button_7.layer.borderWidth = 1.0
        Button_8.layer.borderWidth = 1.0
        Button_9.layer.borderWidth = 1.0
        Button_10.layer.borderWidth = 1.0
        Button_11.layer.borderWidth = 1.0
        Button_12.layer.borderWidth = 1.0
        Button_13.layer.borderWidth = 1.0
        Button_14.layer.borderWidth = 1.0
        Button_15.layer.borderWidth = 1.0
        Button_16.layer.borderWidth = 1.0
        Button_17.layer.borderWidth = 1.0
        Button_18.layer.borderWidth = 1.0
        Button_19.layer.borderWidth = 1.0
        
        self.view.addSubview(Button_0)
        self.view.addSubview(Button_1)
        self.view.addSubview(Button_2)
        self.view.addSubview(Button_3)
        self.view.addSubview(Button_4)
        self.view.addSubview(Button_5)
        self.view.addSubview(Button_6)
        self.view.addSubview(Button_7)
        self.view.addSubview(Button_8)
        self.view.addSubview(Button_9)
        self.view.addSubview(Button_10)
        self.view.addSubview(Button_11)
        self.view.addSubview(Button_12)
        self.view.addSubview(Button_13)
        self.view.addSubview(Button_14)
        self.view.addSubview(Button_15)
        self.view.addSubview(Button_16)
        self.view.addSubview(Button_17)
        self.view.addSubview(Button_18)
        self.view.addSubview(Button_19)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
