//
//  SelectPainterResponse.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation

struct SelectPainterResponse: Codable {
    let words: [String]
    let user: User
    
}
