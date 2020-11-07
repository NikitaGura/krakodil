//
//  MapResponse.swift
//  Krakodil
//
//  Created by Nikita Gura on 07/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation
import UIKit

func mapResponse(lineResponse: LineResponse) -> Line {
    let pointsMapped = lineResponse.points.map({CGPoint(x: $0.x, y: $0.y)})
    let color = UIColor(red: CGFloat(lineResponse.color_line.R), green: CGFloat(lineResponse.color_line.G), blue: CGFloat(lineResponse.color_line.B), alpha: 1)
    return Line(color: color, width: lineResponse.width_line, points: pointsMapped)
}
