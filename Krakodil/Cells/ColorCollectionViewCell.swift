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
    @IBOutlet weak var imageColor: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderColor = UIColor.orange.cgColor
        containerView.layer.cornerRadius = 25
        containerView.layer.masksToBounds = true
        
        imageColor.image = imageColor.image?.withRenderingMode(.alwaysTemplate)
        
    }
    
    func setSelected(){
         containerView.layer.borderWidth = 1
    }
    
    func setUnSelected(){
         containerView.layer.borderWidth = 0
    }
    

}
