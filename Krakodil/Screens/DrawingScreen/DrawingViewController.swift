//
//  ViewController.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/5/19.
//  Copyright © 2019 Nikita Gura. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, Storyboarded, DrawingViewControllerDelegate {
    
    @IBOutlet weak var heightInputChat: NSLayoutConstraint!
    @IBOutlet weak var playersCount: UILabel!
    @IBOutlet weak var selectWorldLabel: UILabel!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var inputMessage: UITextField!
    @IBOutlet weak var canvasView: Canvas!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var secondsLeft: UILabel!
    

    var selectWord: String?{
        didSet{
            if(isPainter){
                selectWorldLabel.text = selectWord
                countTimer = gameDuration
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startGameTimer), userInfo: nil, repeats: true)
            }
        }
    }
    var countPlayer: Int = 0 {
        didSet{
            playersCount.text = "\(countPlayer)/8"
        }
    }
    var isPainter: Bool = false {
        didSet{
            if(isPainter){
                heightInputChat.constant = 0
                isHiddenChat(hidden: true)
            } else {
                selectWorldLabel.text = ""
                isHiddenChat(hidden: false)
            }
        }
    }
    
    var countTimer = 0
    var user: User?
    var socketProvider: SocketProvider?
    var room: Room?
    var messages: [Message] = []
    var settingsDrawerViewController: SettingsDrawerViewController?
    var selectWordController: SelectWordViewController?
    var timer: Timer?
    
    var gameDuration = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countPlayer = room?.room_users?.count ?? 0
        selectWorldLabel.text = ""
        let nibCell = UINib(nibName: CellNames.messageTableViewCell, bundle: nil)
        messagesTableView.register(nibCell, forCellReuseIdentifier: CellNames.messageTableViewCell)
        messagesTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        canvasView.drawingViewControllerDelegate = self
        canvasView.setUpCanvas()
        socketProvider!.emitJoinToRoom(room: room!)
        setLoadedLines(lineResponse: room?.room_points)
        secondsLeft.text = countTimer == 0 ? "" : "\(countTimer)"
        
        socketProvider?.onMessage(completion: listenMessage)
        socketProvider?.onSelectPainter(completion: listenSelectPainter)
        socketProvider?.onConnectUserRoom(completion: listenUserConnect)
        socketProvider?.onLeaveUserRoom(completion: listenUserDisconected)
        socketProvider?.onSendWinner(completion: listenWinner)
        socketProvider?.onSendMinusGameSecond(completion: listenSeconds)
        socketProvider?.onOnePlayerLeft(completion: listenOnePlayerLeft)
        socketProvider?.onSendNextPainter(completion: listenNextPainter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socketProvider?.emitLeaveRoom(room: room!)
        selectWordController?.stopTimer()
        selectWordController?.listenClose()
        stopTimer()
        if(isPainter && room?.room_users?.count ?? 0 > 1){
            let indexUser = room?.room_users?.firstIndex(where: {$0.id_device == user?.id_device})
            let nextIndexUser = ((indexUser ?? 0) + 1) == room?.room_users?.count ? 0 : (indexUser ?? 0) + 1
            let nextUser = room?.room_users?[nextIndexUser]
            if( nextUser != nil){
                socketProvider?.emitNextPainter(user: nextUser!, room: room!)
           
            }else{
                // TODO: Analytics
            }
        }
        socketProvider = nil;

    }
    
    func showSelectorWords(words: [String]){
        isPainter = true
        let selectWordViewController = SelectWordViewController.instantiate()
        selectWordViewController.delegateDrawingViewController = self
        selectWordViewController.words = words
        selectWordViewController.startTimer()
        present(selectWordViewController, animated: true, completion: nil)
    }
    
    func cleanInput(){
        view.endEditing(true)
        sendButton.isEnabled = true
        inputMessage.text = ""
    }
    
    func listenUserConnect(user: User){
        countPlayer += 1
        room?.room_users?.append(user)
        messages.insert(Message(user: user, id_room: (room?.id_room)!, message: Strings.ROOMS_CONNECTED), at: 0)
        messagesTableView.reloadData()
    }
    
    func listenUserDisconected(user: User){
        countPlayer -= 1
        room?.room_users?.removeAll(where: { (u) -> Bool in
            return user.id_device == u.id_device
        })
        messages.insert(Message(user: user, id_room: (room?.id_room)!, message: Strings.ROOMS_DISCONNECTED), at: 0)
        messagesTableView.reloadData()
    }
    
    func listenMessage(message: Message){
        messages.insert(message, at: 0)
        messagesTableView.reloadData()
        if(message.user.id_device == user?.id_device){
            cleanInput()
        }
        if let selectedWorld = self.selectWord {
            if(message.message.elementsEqual(selectedWorld)){
                socketProvider?.emitGetWinner(user: message.user, room: room!, selectWord: selectedWorld)
            }
        }
    }
    
    func listenSelectPainter(selectPainterResponse: SelectPainterResponse){
        if(selectPainterResponse.user.id_device == user?.id_device){
            showSelectorWords(words: selectPainterResponse.words)
        }else{
            isPainter = false
        }
        title = selectPainterResponse.user.name
    }
    
    func listenWinner(winnerResponse: WinnerResponse){
        title = winnerResponse.user.name
        stopTimer()
        let selectWordViewController = SelectWordViewController.instantiate()
        selectWordViewController.delegateDrawingViewController = self
        selectWordViewController.winner = winnerResponse.user
        selectWordViewController.selectWord = winnerResponse.select_word
        if (settingsDrawerViewController != nil){
            settingsDrawerViewController?.dismiss(animated: false, completion: nil)
        }
        if(winnerResponse.user.id_device == self.user?.id_device){
            isPainter = true
            selectWordViewController.words = winnerResponse.words
            selectWordViewController.startTimer()
        }else{
            selectWordViewController.isHiddenButtons = true
            isPainter = false
        }
        present(selectWordViewController, animated: true, completion: nil)
    }
    
    func listenOnePlayerLeft(){
        stopTimer()
        secondsLeft.text = ""
        selectWordController?.stopTimer()
        selectWordController?.listenClose()
        settingsDrawerViewController?.dismiss(animated: false, completion: nil)
        selectWordController = nil
    }
    
    func listenSeconds(seconds: String){
        secondsLeft.text = seconds == "0" ? "" : seconds
    }
    
    func listenNextPainter(nextPainter: NextPainter){
        selectWordController?.listenClose();
        title = nextPainter.user.name
        if(nextPainter.user.id_device == user?.id_device){
            let selectWordViewController = SelectWordViewController.instantiate()
            selectWordViewController.delegateDrawingViewController = self
            selectWordViewController.words = nextPainter.words
            selectWordViewController.isHiddenButtons = false
            selectWordViewController.startTimer()
            present(selectWordViewController, animated: true, completion: nil)
        }
    }
    
    func setLoadedLines(lineResponse: [LineResponse]?){
        if let lR = lineResponse {
            let lines = lR.map(mapResponse)
            canvasView?.addLines(lines: lines)
        }
    }
    
    func isHiddenChat(hidden: Bool){
        inputMessage.isHidden = hidden
        sendButton.isHidden = hidden
        heightInputChat.constant = hidden ? 0 : 48
    }
    
    @objc func startGameTimer(){
        socketProvider?.emitMinusGameSecond(seconds: String(countTimer), room: room!)
        countTimer -= 1
        if countTimer == -1 {
            timer?.invalidate()
            let indexUser = room?.room_users?.firstIndex(where: {$0.id_device == user?.id_device})
            let nextIndexUser = ((indexUser ?? 0) + 1) == room?.room_users?.count ? 0 : (indexUser ?? 0) + 1
            let nextUser = room?.room_users?[nextIndexUser]
            if( nextUser != nil){
                socketProvider?.emitNextPainter(user: nextUser!, room: room!)
           
            }else{
                // TODO: Analytics
            }
            isPainter = false
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
        countTimer = 0
    }
     
    @IBAction func tapedSettingDraw(_ sender: Any) {
        if (isPainter) {
            let handlerSelectedColor:(_ color: UIColor, _ width: Float)->Void = { (color ,width) in
                self.canvasView.selectedColor = color
                self.canvasView.selectedWidth = width
            }
            
            settingsDrawerViewController = SettingsDrawerViewController.instantiate()
            settingsDrawerViewController?.selectedColor = canvasView.selectedColor
            settingsDrawerViewController?.selectedWidth = canvasView.selectedWidth
            settingsDrawerViewController?.handlerSelectedColor = handlerSelectedColor
            self.present(settingsDrawerViewController!, animated: false, completion: nil)
        }
    }
    
    
    @IBAction func tappedClear(_ sender: Any) {
        if(isPainter){
            let alert = UIAlertController(title: Strings.GENERAL_CLEAR_ALL, message: Strings.GENERAL_ARE_YOU_SURE, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: Strings.GENERAL_YES, style: .default, handler: { (UIAlertAction) in
                self.canvasView.clear()
            }))
            alert.addAction(UIAlertAction(title: Strings.GENERAL_NO, style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if( inputMessage.text?.count ?? 0 > 0 && user != nil) {
            sender.isEnabled = false
            socketProvider?.sendMessage(room: room!, user: user!, message: inputMessage.text!)
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
