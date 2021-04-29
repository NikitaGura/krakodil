//
//  MessageTableViewCell.swift
//  Krakodil
//
//  Created by Nikita Gura on 10/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    var message: Message? {
        didSet{
            userMessage.text = "\(message?.user.name ?? ""):  "
            textMessage.text = "  \(message?.message ?? "")  "
        }
    }
    var user: User? {
        didSet{
            textMessage.backgroundColor = user?.id_device == message?.user.id_device ? UIColor.MyTheme.orange_message : UIColor.MyTheme.green_message
        }
    }
    
    @IBOutlet weak var textMessage: UILabel!
    @IBOutlet weak var userMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        textMessage.layer.cornerRadius = 15
        textMessage.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
