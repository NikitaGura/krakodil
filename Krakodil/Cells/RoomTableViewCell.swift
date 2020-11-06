//
//  RoomTableViewCell.swift
//  Krakodil
//
//  Created by Nikita Gura on 01/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var userCount: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var room: Room?{
        didSet{
            name.text = room?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.borderColor = UIColor.black.cgColor
        content.layer.cornerRadius = 12
        content.layer.masksToBounds = true
        content.layer.borderWidth = 2
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
