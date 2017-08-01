//
//  TopViewController.swift
//  黒ひげ
//
//  Created by 築山朋紀 on 2017/04/11.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button1.layer.cornerRadius = 30 //ボタンを丸める
        button2.layer.cornerRadius = 30
        button3.layer.cornerRadius = 30
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
