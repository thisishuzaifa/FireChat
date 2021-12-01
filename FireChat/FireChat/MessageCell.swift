//
//  MessageCell.swift
//  FireChat
//
//  Created by Muhammad Huzaifa Khalid on 2021-11-29.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBodyBackground: UIView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var senderImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
