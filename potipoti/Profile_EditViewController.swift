//
//  Profile_EditViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/08/16.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Profile_EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //使うUI
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var TextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        
        //TextFieldにuserNmaeを表示する
        TextField.text = user?.displayName

    }
    
    @IBAction func Save() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = TextField.text
        changeRequest?.commitChanges() { (error) in
            
            if let error = error {
                print(error)
            }
            print("ユーザーネームは...\(user?.displayName)です")
            print("ユーザーIDは...\(uid)です")
        }
        //画面を戻る
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Cancel() {
        //画面を戻る(画面遷移)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Profile_image_Ebit() {
        presentPickerController(sourceType: .photoLibrary)
    }

    //カメラ、アルバムの呼び出しメソッド(カメラorアルバムのソースタイプが引き数)
    func presentPickerController(sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    //写真が選択されたときに呼び出されるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        //ImageViewに選択した画像を表示する
        ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let user = Auth.auth().currentUser
        let uid = user?.uid 
        print("imageを送信する")
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://potipoti-e1d0e.appspot.com")
        if let data = UIImagePNGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!) {
            let riversRef = storageRef.child("image/\(uid).jpg")
            riversRef.putData(data, metadata: nil, completion: { metaData, error in
                print(metaData)
                print("imageを送信した")
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
