//
//  ColorApp.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/5/19.
//  Copyright © 2019 Nikita Gura. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    struct MyTheme {
        static var grayCanvasColor: UIColor  { return .white  }
        static var backgroundColorApp: UIColor  { return .black  }
        
    }
    
    func rgbJSON() -> [String: CGFloat] {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return [Naming.R: fRed,
                    Naming.G: fGreen,
                    Naming.B: fBlue]
        } else {
            // Could not extract RGBA components: 
            return [Naming.R: 0.0,
                    Naming.G: 0.0,
                    Naming.B: 0.0]
        }
    }
    
    
}
