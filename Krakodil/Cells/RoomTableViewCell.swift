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
            userCount.text = "\(room?.room_users?.count ?? 0)/8"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }

    
}
