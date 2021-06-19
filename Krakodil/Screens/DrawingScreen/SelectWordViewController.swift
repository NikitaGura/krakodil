//
//  SelectWordViewController.swift
//  Krakodil
//
//  Created by Nikita Gura on 10/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import UIKit

class SelectWordViewController: UIViewController, Storyboarded {
    
    weak var delegateDrawingViewController: DrawingViewControllerDelegate? {
        didSet{
            delegateDrawingViewController?.selectWordController = self
        }
    }
    var winner: User?
    var selectWord: String?
    var words = ["one", "two", "three"]
    var isHiddenButtons: Bool = false
    var timer: Timer?
    var timerCount = 0 {
        didSet{
            if(leftSeconds != nil){
                leftSeconds.text = timerCount == 0 ? "": "\(timerCount)"
            }
        }
    }
    var waiting = 20
    
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var leftSeconds: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstButton.setTitle(words[0], for: .normal)
        secondButton.setTitle(words[1], for: .normal)
        thirdButton.setTitle(words[2], for: .normal)
        if let user = winner {
            winnerLabel.text = "\(Strings.ROOM_WINNER): \(user.name)"
            wordLabel.text = selectWord ?? ""
        }else{
            winnerLabel.text = ""
            wordLabel.text = ""
        }
        hideButtons(hidden: isHiddenButtons)
        leftSeconds.text = isHiddenButtons ? "" : "20"
        
        delegateDrawingViewController?.socketProvider?.onSendClosePopupSelector(completion: listenClose)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegateDrawingViewController = nil
    }
    
    func hideButtons(hidden: Bool){
        firstButton.isHidden = hidden
        secondButton.isHidden = hidden
        thirdButton.isHidden = hidden
        firstImage.isHidden = hidden
        secondImage.isHidden = hidden
        thirdImage.isHidden = hidden
    }
    
    @objc func startWait(){
        timerCount -= 1
        if(timerCount == -1){
            stopTimer()
            if(delegateDrawingViewController?.room?.room_users!.count ?? 0 > 1){
                let indexUser = delegateDrawingViewController?.room?.room_users?.firstIndex(where: {$0.id_device == delegateDrawingViewController?.user?.id_device})
                let nextIndexUser = ((indexUser ?? 0) + 1) == delegateDrawingViewController?.room?.room_users?.count ? 0 : (indexUser ?? 0) + 1
                let nextUser = delegateDrawingViewController?.room?.room_users?[nextIndexUser]
                if( nextUser != nil){
                    delegateDrawingViewController?.socketProvider?.emitNextPainter(user: nextUser!, room: (delegateDrawingViewController?.room)!)
               
                }else{
                    // TODO: Analytics
                }
            }
           
            listenClose()
            delegateDrawingViewController?.isPainter = false
        }
    }
        
    @IBAction func firstSelect(_ sender: Any) {
        closePopup()
        delegateDrawingViewController?.selectWord = words[0]
    }
    
    @IBAction func secondSelect(_ sender: Any) {
        closePopup()
        delegateDrawingViewController?.selectWord = words[1]
    }
    
    @IBAction func thirdSelect(_ sender: Any) {
        closePopup()
        delegateDrawingViewController?.selectWord = words[2]
    }
    
    func closePopup(){
        stopTimer()
        delegateDrawingViewController?.isPainter = true
        delegateDrawingViewController?.socketProvider?.emitClosePopupSelector(room: (delegateDrawingViewController?.room!)!)
        listenClose()
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    func listenClose(){
        stopTimer()
        dismiss(animated: true, completion: nil)
        delegateDrawingViewController?.selectWordController = nil
    }
    
    func startTimer(){
        timerCount = waiting
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startWait), userInfo: nil, repeats: true)
    }
    
    
}
