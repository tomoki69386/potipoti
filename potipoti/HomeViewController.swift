//
//  HomeViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/08/15.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    @IBOutlet var TableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
}
