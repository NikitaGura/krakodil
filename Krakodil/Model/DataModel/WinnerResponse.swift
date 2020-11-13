//
//  WinnerResponse.swift
//  Krakodil
//
//  Created by Nikita Gura on 13/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation

struct WinnerResponse: Codable{
    let user: User
    let words: [String]
    let select_word: String
}
