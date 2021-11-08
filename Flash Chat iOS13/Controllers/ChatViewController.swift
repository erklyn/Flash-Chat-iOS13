//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import IHKeyboardAvoiding

class ChatViewController: UIViewController  {

    @IBOutlet weak var keybordAvoider: UIView!
    @IBOutlet var keyboardDismisser: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        //Keyboard Avoiding
        KeyboardAvoiding.avoidingView = keybordAvoider
        KeyboardAvoiding.paddingForCurrentAvoidingView = 10
        
        //Delegates
        messageTextfield.delegate = self
        tableView.dataSource = self
        
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    

    @IBAction func sendPressed(_ sender: UIButton) {
        if messageTextfield.text != "" {
            if let messageBody = messageTextfield.text ,
                let messageSender = Auth.auth().currentUser?.email {
                db.collection(K.FStore.collectionName).addDocument(data: [
                    K.FStore.senderField: messageSender,
                    K.FStore.bodyField: messageBody,
                    K.FStore.dateField: Date().timeIntervalSince1970]) { error in
                    if let e = error {
                        print(e)
                    }else {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            let error = signOutError.localizedDescription
            let alert = UIAlertController(title: "Oops", message: error, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)

            }
        }
    }
//MARK: - UITableView

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
            
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftviewImage.isHidden = true
            cell.rightimageView.isHidden = false
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }else{
            cell.leftviewImage.isHidden = false
            cell.rightimageView.isHidden = true
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.blue)
            cell.label.textColor = UIColor(named: K.BrandColors.lightBlue)
        }
        return cell
        }
    }

//MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
}


//MARK: - Fetching Data
extension ChatViewController {
    func loadMessages(){
        
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
                self.messages = []
                if let e = error {
                    print("Firestore problem\(e)")
                }else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let sender = data[K.FStore.senderField] as? String , let body = data[K.FStore.bodyField ] as? String {
                                let newMessage = Message(sender: sender, body: body)
                                self.messages.append(newMessage)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1 , section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
}
