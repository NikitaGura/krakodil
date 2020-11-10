//
//  Message.swift
//  Krakodil
//
//  Created by Nikita Gura on 10/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation

struct Message: Codable {
    let user: User
    let id_room: String
    let message: String
}
