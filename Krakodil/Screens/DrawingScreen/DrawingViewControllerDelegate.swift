//
//  ProtocolDrawingViewController.swift
//  Krakodil
//
//  Created by Nikita Gura on 10/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation

protocol DrawingViewControllerDelegate: class{
    var selectWord: String? { get set }
    var isPainter: Bool {get set}
    var room: Room? {get set}
    var user: User? {get set}
    var socketProvider: SocketProvider? {get set}
}
