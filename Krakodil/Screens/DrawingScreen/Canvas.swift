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
    
    weak var drawingViewControllerDelegate: DrawingViewControllerDelegate?
    var selectedColor: UIColor = .black
    var selectedWidth: Float = 5.0
    var linesPoints = [Line]()
    
    init () {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setUpCanvas(){
        drawingViewControllerDelegate?.socketProvider?.onDraw(completion: listenLine)
        drawingViewControllerDelegate?.socketProvider?.onCleanLines(completion: listenClear)
        drawingViewControllerDelegate?.socketProvider?.onOnePlayerLeft(completion: listenOneLeftPlayer)
        drawingViewControllerDelegate?.socketProvider?.onSendClosePopupSelector(completion: listenClose)
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
        if(drawingViewControllerDelegate!.isPainter){
            guard let point = touches.first?.location(in: self) else {return}
            guard var lastLine = linesPoints.popLast() else {return}
            lastLine.points.append(point)
            linesPoints.append(lastLine)
            setNeedsDisplay()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(drawingViewControllerDelegate!.isPainter){
            guard let point = touches.first?.location(in: self) else {return}
            linesPoints.append(Line.init(color: selectedColor , width: selectedWidth, points: [point]))
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(drawingViewControllerDelegate!.isPainter){
            guard let lastLine = linesPoints.last else {return}
            drawingViewControllerDelegate?.socketProvider?.emitDraw(line: lastLine, room: drawingViewControllerDelegate!.room!)
        }
    }
    
    func clear(){
            linesPoints.removeAll()
            setNeedsDisplay()
            drawingViewControllerDelegate?.socketProvider?.emitCleanLines(room: drawingViewControllerDelegate!.room!)
    }
    
    func listenClear(isClean: Bool = true){
        if(isClean){
            listenClose()
        }
    }
    
    func listenClose(){
        linesPoints.removeAll()
        setNeedsDisplay()
    }
    
    func listenLine(line: Line){
        linesPoints.append(line)
        setNeedsDisplay()
    }
    
    func listenOneLeftPlayer(){
        listenClear(isClean: true)
        drawingViewControllerDelegate?.isPainter = false
    }
    
    func addLines(lines: [Line]){
        linesPoints = lines
        setNeedsDisplay()
    }
    
    
}
