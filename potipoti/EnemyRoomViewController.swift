//
//  EnemyRoomViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/08/25.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class EnemyRoomViewController: UIViewController {
    
    let userDefault = UserDefaults.standard
    var ref: DatabaseReference! //Firebase
    let user = Auth.auth().currentUser
    
    //使うボタンたち
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
    
    //ハズレかアタリか表示
    @IBOutlet var HanteiLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
