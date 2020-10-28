//
//  Storyboarded.swift
//  Krakodil
//
//  Created by Nikita Gura on 29/08/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let storyboardIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
