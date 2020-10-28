//
//  SocketProvider.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/10/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import Foundation
import SocketIO

public class SocketProvider{
    var socket: SocketIOClient!
    var manager: SocketManager!
    
    init() {
        manager = SocketManager(socketURL: URL(string: SocketAPI.domian)!, config: [.log(true), .compress])
        socket =  manager.defaultSocket
        socket.connect()
    }
    
    func emitDraw(line: Line){
        let points = line.points.map({[Naming.x :$0.x, Naming.y: $0.y]})
        socket.emit(SocketAPI.eventDraw, [Naming.points :points,
                                          Naming.colorLine: line.color.rgbJSON(),
                                          Naming.widthLine: line.width ])
    }
    
    func emitCleanLines(){
        socket.emit(SocketAPI.eventCleanLines,[Naming.isClean: true])
    }
    
    func onCleanLines(completion: @escaping  (_ isClean: Bool)->()){
        socket.on(SocketAPI.eventCleanLines){ data, ack  in
            let string = data[0] as! String
            let response = string.data(using: .utf8)!
            do {
                let cleanBool = try JSONDecoder().decode(CleanBool.self, from: response)
                completion(cleanBool.is_Clean)
            }
            catch let error as NSError {
                print(error)
            }
        }
    }
    
    func onDraw(completion: @escaping  (_ line: Line)->()){
        socket.on(SocketAPI.eventDraw){ data, ack  in
            let string = data[0] as! String
            let response = string.data(using: .utf8)!
            do {
                let lineResponse = try JSONDecoder().decode(LineResponse.self, from: response)
                let pointsMapped = lineResponse.points.map({CGPoint(x: $0.x, y: $0.y)})
                let color = UIColor(red: CGFloat(lineResponse.color_line.R), green: CGFloat(lineResponse.color_line.G), blue: CGFloat(lineResponse.color_line.B), alpha: 1)
                completion(Line(color: color, width: lineResponse.width_line, points: pointsMapped))
            }
            catch let error as NSError {
                print(error)
            }
        }
    }
    
}

