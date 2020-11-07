//
//  Canvas.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/5/19.
//  Copyright © 2019 Nikita Gura. All rights reserved.
//

import Foundation
import UIKit

class Canvas: UIView{
    
    var selectedColor: UIColor = .black
    var selectedWidth: Float = 5.0
    var linesPoints = [Line]()
    var socketProvider: SocketProvider?
    var room: Room!
    init () {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setUpCanvas(room: Room){
        self.room = room
        socketProvider?.onDraw(completion: listenLine)
        socketProvider?.onCleanLines(completion: listenClear)
    }
    
    override func draw( _ rect: CGRect){
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        context.setLineCap(.round)
        linesPoints.forEach { (line) in
            
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.width))
            for (index, point) in line.points.enumerated(){
                if(index == 0){
                    context.move(to: point)
                }else{
                    context.addLine(to: point)
                }
            }
            context.strokePath()
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {return}
        guard var lastLine = linesPoints.popLast() else {return}
        lastLine.points.append(point)
        linesPoints.append(lastLine)
        setNeedsDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {return}
        linesPoints.append(Line.init(color: selectedColor , width: selectedWidth, points: [point]))
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let lastLine = linesPoints.last else {return}
        socketProvider?.emitDraw(line: lastLine, room: room)
    }
    
    func clear(){
        linesPoints.removeAll()
        setNeedsDisplay()
        socketProvider?.emitCleanLines(room: room)
    }
    
    func listenClear(isClean: Bool){
        if(isClean){
            linesPoints.removeAll()
            setNeedsDisplay()
        }
    }
    
    func listenLine(line: Line){
        linesPoints.append(line)
        setNeedsDisplay()
    }
    
    func addLines(lines: [Line]){
        linesPoints = lines
        setNeedsDisplay()
    }
    
    
}
