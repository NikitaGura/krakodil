//
//  Room.swift
//  Krakodil
//
//  Created by Nikita Gura on 01/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation

struct Room: Codable {
   let name: String
   let id_room: String
}

struct RoomsResponse: Codable {
    let rooms: [Room]
}
