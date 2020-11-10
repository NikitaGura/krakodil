//
//  SocketAPI.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/10/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//
import Foundation

struct SocketAPI {
    static let domian = "http://localhost:3000"
    static let eventDraw = "event_draw"
    static let eventCleanLines = "event_clean_lines"
    static let event_user_join_to_room = "event_user_join_to_room"
    static let event_user_disconnect_from_room = "event_user_disconnect_from_room"
    static let event_send_message_room = "event_send_message_room"
    static let event_message_room = "event_message_room"
}
