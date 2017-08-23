//
//  RoomViewController.swift
//  potipoti
//
//  Created by 築山朋紀 on 2017/08/19.
//  Copyright © 2017年 築山朋紀. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RoomViewController: JSQMessagesViewController{
    
    var ref: DatabaseReference! //Firebase
    let user = Auth.auth().currentUser
    var messages: [JSQMessage]?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    let userDefault = UserDefaults.standard
    
    func setupFirebase() {
        
        // firebaseのセットアップ
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        
        self.ref?.child("Active_users").child(user!.uid).child("chat").observe(.childAdded, with: { [weak self](snapshot) -> Void in
            
            let text = String(describing: snapshot.childSnapshot(forPath: "text").value!)
            let sender = String(describing: snapshot.childSnapshot(forPath: "sender").value!)
            let name = String(describing: snapshot.childSnapshot(forPath: "name").value!)
            let message = JSQMessage(senderId: sender, displayName: name, text: text)
            self?.messages?.append(message!)
            self?.finishSendingMessage()
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputToolbar!.contentView!.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        
        let userName = user?.displayName
        let uid = user?.uid
        
        //自分のsenderId, senderDisokayNameを設定
        self.senderId = uid
        self.senderDisplayName = userName
        
        //吹き出しの設定
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        //アバターの設定
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "Swift-Logo")!, diameter: 64)
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "Swift-Logo")!, diameter: 64)
        
        //メッセージデータの配列を初期化
        self.messages = []
        setupFirebase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sendボタンが押された時に呼ばれる
    func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {

        //メッセージの送信処理を完了する(画面上にメッセージが表示される)
        self.finishReceivingMessage(animated: true)
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        self.ref.child("Active_users").child(user!.uid).child("chat").setValue(["name": senderDisplayName, "sender":senderId, "text": text])
    }
    //アイテムごとに参照するメッセージデータを返す
    func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages?[indexPath.item]
    }
    
    //アイテムごとのMessageBubble(背景)を返す
    func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    //アイテムごとにアバター画像を返す
    func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    //アイテムの総数を返す
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.messages?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages!.count
    }

}
