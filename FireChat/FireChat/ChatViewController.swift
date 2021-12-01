//
//  ChatViewController.swift
//  FireChat
//
//  Created by Muhammad Huzaifa Khalid on 2021-11-29.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var heightConstraint:
    NSLayoutConstraint!
    @IBAction func sendButtonTapped(_ sender: Any) {
        if let text = textField.text {
        let messagesDB = Database.database().reference().child("Messages")
        let messageDict = [
        "Sender": Auth.auth().currentUser?.email,
        "MessageBody": text
        ]
        // set value in firebase db
        messagesDB.childByAutoId().setValue(messageDict) { (error, ref) in
        if let err = error {
        print(err)
        } else {
        print("Message successfully saved")
        }
        // clear the textField after sending
        self.textField.text = ""
        }
        }
        
        
    }
    
    
    
    var messages: [Message] = []
    override func viewDidLoad() {
    super.viewDidLoad()
    // set up this view controller as the tableView's delegate and dataSource
    tableView.delegate = self
    tableView.dataSource = self
    // register our custom cell xib
    tableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "messageCell")
    getMessages()
    }
    override func viewDidAppear(_ animated: Bool) {
    scrollToBottom()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
    let message = messages[indexPath.row]
    cell.messageBodyLabel.text = message.messageBody
    cell.senderLabel.text = message.sender
    // if the cell is showing our message make it a different colour than other user messages
    if let email = Auth.auth().currentUser?.email, email == message.sender {
    cell.messageBodyBackground.backgroundColor = UIColor.green
    cell.senderImageView.image = UIImage(named: "stars")
    } else {
    cell.messageBodyBackground.backgroundColor = UIColor.orange
    cell.senderImageView.image = UIImage(named: "smile")
    }
    return cell
    }
    // scrolls the table view to the bottom so we can see the most recent messages
    func scrollToBottom() {
    guard tableView.numberOfRows(inSection: 0) > 0 else { return }
    let indexPath = IndexPath(row: messages.count - 1, section: 0)
    tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    func getMessages() {
    // get all the messages in our firebase Messages db
    let messagesDB = Database.database().reference().child("Messages")
    // observe for changes in firebase Messages db
    messagesDB.observe(.childAdded) { (snapShot) in
    // we originally stored our data as a dictionary, ie ["Sender": "an email address", "MessageBody": "blah blah"], so we need to cast the value we're getting from firebase back into a dictionary
    if let value = snapShot.value as? Dictionary<String, String>,
    let messageBody = value["MessageBody"],
    let sender = value["Sender"] {
    // create a Message object from the data we get back from firebase
    let message = Message(sender: sender, messageBody: messageBody)
    // add our new messages to our messages array
    self.messages.append(message)
    // reload our table
    self.tableView.reloadData()
    // ensure our table is scrolled to the bottom where the most recent message is
    self.scrollToBottom()
    }
    }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.5) {
    self.heightConstraint.constant = 360
    self.view.layoutIfNeeded()
    self.scrollToBottom()
    }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.5) {
    self.heightConstraint.constant = 100
    self.view.layoutIfNeeded()
    self.scrollToBottom()
    }
    }
}

