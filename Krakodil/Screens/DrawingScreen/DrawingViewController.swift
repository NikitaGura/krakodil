//
//  ViewController.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/5/19.
//  Copyright © 2019 Nikita Gura. All rights reserved.
//

import UIKit



class DrawingViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var inputMessage: UITextField!
    @IBOutlet weak var canvasView: Canvas!
    @IBOutlet weak var sendButton: UIButton!
    
    var user: User?
    var socketProvider: SocketProvider!
    var room: Room!
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: CellNames.messageTableViewCell, bundle: nil)
        messagesTableView.register(nibCell, forCellReuseIdentifier: CellNames.messageTableViewCell)
        messagesTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        canvasView.socketProvider = socketProvider
        socketProvider.emitJoinToRoom(room: room)
        canvasView.setUpCanvas(room: room)
        getLinesRoom(room: room) { (lines) in
            self.canvasView.addLines(lines: lines ?? [])
        } errorResponse: {
            // TODO: Analytics
        }
        socketProvider.onMessage { message in
            self.messages.insert(message, at: 0)
            self.messagesTableView.reloadData()
            if(message.user.id_device == self.user?.id_device){
                self.cleanInput()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socketProvider.emitLeaveRoom(room: room)
    }
    
    func cleanInput(){
        view.endEditing(true)
        sendButton.isEnabled = true
        inputMessage.text = ""
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
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if( inputMessage.text?.count ?? 0 > 0 && user != nil) {
            sender.isEnabled = false
            socketProvider.sendMessage(room: room, user: user!, message: inputMessage.text!)
        }
    }
    
}

extension DrawingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = messagesTableView.dequeueReusableCell(withIdentifier: CellNames.messageTableViewCell) as! MessageTableViewCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        cell.message = messages[indexPath.row]
        return cell
    }
    
}
