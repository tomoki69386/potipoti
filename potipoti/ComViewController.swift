//
//  ComViewController.swift
//  黒ひげ
//
//  Created by 築山朋紀 on 2017/04/11.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit

class ComViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    var defaults: UserDefaults = UserDefaults.standard
    var number: Int = 0
    var count: Int = 19
    var j: Int = 0 //あたりかハズレを調べる変数
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.isHidden = false
        button2.isHidden = false
        button3.isHidden = false
        button4.isHidden = false
        button5.isHidden = false
        button6.isHidden = false
        button7.isHidden = false
        button8.isHidden = false
        button9.isHidden = false
        button10.isHidden = false
        button11.isHidden = false
        button12.isHidden = false
        button13.isHidden = false
        button14.isHidden = false
        button15.isHidden = false
        button16.isHidden = false
        button17.isHidden = false
        button18.isHidden = false
        button19.isHidden = false
        button0.isHidden = false
        
        //0~19までのランダムな数字を発生させる
        number = Int(arc4random_uniform(20))
        
        print(number)
        
        if number > 18 { //19のとき
            defaults.set(19, forKey: "hoge")
            
        }else if number > 17 { //18のとき
            defaults.set(18, forKey: "hoge")
            
        }else if number > 16 { //17のとき
            defaults.set(17, forKey: "hoge")
            
        }else if number > 15 { //16のとき
            defaults.set(16, forKey: "hoge")
            
        }else if number > 14 { //15のとき
            defaults.set(15, forKey: "hoge")
            
        }else if number > 13 { //14のとき
            defaults.set(14, forKey: "hoge")
            
        }else if number > 12 { //13のとき
            defaults.set(13, forKey: "hoge")
            
        }else if number > 11 { //12のとき
            defaults.set(12, forKey: "hoge")
            
        }else if number > 10 { //11のとき
            defaults.set(11, forKey: "hoge")
            
        }else if number > 9 { //10のとき
            defaults.set(10, forKey: "hoge")
            
        }else if number > 8 { //9のとき
            defaults.set(9, forKey: "hoge")
            
        }else if number > 7 { //8のとき
            defaults.set(8, forKey: "hoge")
            
        }else if number > 6 { //7のとき
            defaults.set(7, forKey: "hoge")
            
        }else if number > 5 { //6のとき
            defaults.set(6, forKey: "hoge")
            
        }else if number > 4 { //5のとき
            defaults.set(5, forKey: "hoge")
            
        }else if number > 3 { //4のとき
            defaults.set(4, forKey: "hoge")
            
        }else if number > 2 { //3のとき
            defaults.set(3, forKey: "hoge")
            
        }else if number > 1 { //2のとき
            defaults.set(2, forKey: "hoge")
            
        }else if number > 0 { //1のとき
            defaults.set(1, forKey:"hoge")
            
        }else { //0のとき
            defaults.set(0, forKey: "hoge")
        }
        //どれをはずれにするか
        j = defaults.integer(forKey: "hoge")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hoge0() {
        if j == 0 {
            self.hazure()
        }else {
            self.atari()
        }
        button0.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge1() {
        if j == 1 {
            self.hazure()
        }else {
            self.atari()
        }
        button1.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge2() {
        if j == 2 {
            self.hazure()
        }else {
            self.atari()
        }
        button2.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge3() {
        if j == 3 {
            self.hazure()
        }else {
            self.atari()
        }
        button3.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge4() {
        if j == 4 {
            self.hazure()
        }else {
            self.atari()
        }
        button4.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge5() {
        if j == 5 {
            self.hazure()
        }else {
            self.atari()
        }
        button5.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge6() {
        if j == 6 {
            self.hazure()
        }else {
            self.atari()
        }
        button6.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge7() {
        if j == 7 {
            self.hazure()
        }else {
            self.atari()
        }
        button7.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge8() {
        if j == 8 {
            self.hazure()
        }else {
            self.atari()
        }
        button8.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge9() {
        if j == 9 {
            self.hazure()
        }else {
            self.atari()
        }
        button9.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge10() {
        if j == 10 {
            self.hazure()
        }else {
            self.atari()
        }
        button10.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge11() {
        if j == 11 {
            self.hazure()
        }else {
            self.atari()
        }
        button11.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge12() {
        if j == 12 {
            self.hazure()
        }else {
            self.atari()
        }
        button12.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge13() {
        if j == 13 {
            self.hazure()
        }else {
            self.atari()
        }
        button13.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge14() {
        if j == 14 {
            self.hazure()
        }else {
            self.atari()
        }
        button14.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge15() {
        if j == 15 {
            self.hazure()
        }else {
            self.atari()
        }
        button15.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge16() {
        if j == 16 {
            self.hazure()
        }else {
            self.atari()
        }
        button16.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge17() {
        if j == 17 {
            self.hazure()
        }else {
            self.atari()
        }
        button17.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge18() {
        if j == 18 {
            self.hazure()
        }else {
            self.atari()
        }
        button18.isHidden = true
        self.owari()
    }
    
    @IBAction func hoge19() {
        if j == 19 {
            self.hazure()
        }else {
            self.atari()
        }
        button19.isHidden = true
        self.owari()
    }
    
    func hazure() {
        label.text = ("ハズレ")
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
    
    func atari() {
        label.text = ("セーフ")
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
            
            // アラートにボタンをつける
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)
                
            }))
            
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
    }
}
