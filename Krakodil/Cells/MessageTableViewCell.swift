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
            userMessage.text = "\(message?.user.name ?? ""):  \(message?.message ?? "")"
        }
    }
    
    @IBOutlet weak var userMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
