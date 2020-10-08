//
//  ColorCollectionViewCell.swift
//  Krakodil
//
//  Created by Nikita Gura on 29/08/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.cornerRadius = 25
        containerView.layer.masksToBounds = true
        
        colorView.layer.cornerRadius = 22
        colorView.layer.borderColor = UIColor.black.cgColor
    }
    
    func setSelected(){
         containerView.layer.borderWidth = 1
         colorView.layer.borderWidth = 1
    }
    
    func setUnSelected(){
         containerView.layer.borderWidth = 0
         colorView.layer.borderWidth = 0
    }
    

}
