//
//  Message.swift
//  FireChat
//
//  Created by Muhammad Huzaifa Khalid on 2021-11-29.
//

import Foundation


class Message {
var sender: String
var messageBody: String
init(sender: String, messageBody: String) {
self.sender = sender
self.messageBody = messageBody
}
}
