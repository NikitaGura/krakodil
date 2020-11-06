//
//  ViewController.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/5/19.
//  Copyright © 2019 Nikita Gura. All rights reserved.
//

import UIKit



class DrawingViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var canvasView: Canvas!
    var socketProvider: SocketProvider!
    var room: Room!
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.socketProvider = socketProvider
        socketProvider.emitJoinToRoom(room: room)
        canvasView.setUpCanvas(room: room)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socketProvider.emitLeaveRoom(room: room)
    }
    
    @IBAction func tapedSettingDraw(_ sender: Any) {
        let handlerSelectedColor:(_ color: UIColor, _ width: Float)->Void = { (color ,width) in
            self.canvasView.selectedColor = color
            self.canvasView.selectedWidth = width
        }
        
        let settingsDrawerViewController = SettingsDrawerViewController.instantiate()
        settingsDrawerViewController.selectedColor = canvasView.selectedColor
        settingsDrawerViewController.selectedWidth = canvasView.selectedWidth
        settingsDrawerViewController.handlerSelectedColor = handlerSelectedColor
        self.present(settingsDrawerViewController, animated: false, completion: nil)
    }
    
    @IBAction func tappedClear(_ sender: Any) {
        let alert = UIAlertController(title: Strings.GENERAL_CLEAR_ALL, message: Strings.GENERAL_ARE_YOU_SURE, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: Strings.GENERAL_YES, style: .default, handler: { (UIAlertAction) in
            self.canvasView.clear()
        }))
        alert.addAction(UIAlertAction(title: Strings.GENERAL_NO, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

