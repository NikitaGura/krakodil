//
//  Point.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/10/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation


struct LineResponse: Codable {
    let points: [Point]
    let width_line: Float
    let color_line: RGB
}

struct Point: Codable {
    let y: Double
    let x: Double
}

struct RGB: Codable {
    let R: Float
    let G: Float
    let B: Float
}
