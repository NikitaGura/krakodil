//
//  SelectWordViewController.swift
//  Krakodil
//
//  Created by Nikita Gura on 10/11/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import UIKit

class SelectWordViewController: UIViewController, Storyboarded {
    
    weak var delegateDrawingViewController: DrawingViewControllerDelegate?
    var winner: User?
    var selectWord: String?
    var words = ["one", "two", "three"]
    var isHiddenButtons: Bool = false
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
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
        delegateDrawingViewController?.socketProvider?.onSendClosePopupSelector(completion: listenClose)
    }
    
    func hideButtons(hidden: Bool){
        firstButton.isHidden = hidden
        secondButton.isHidden = hidden
        thirdButton.isHidden = hidden
    }
        
    @IBAction func firstSelect(_ sender: Any) {
        delegateDrawingViewController?.selectWord = words[0]
        closePopup()
    }
    
    @IBAction func secondSelect(_ sender: Any) {
        delegateDrawingViewController?.selectWord = words[1]
        closePopup()
    }
    
    @IBAction func thirdSelect(_ sender: Any) {
        delegateDrawingViewController?.selectWord = words[2]
        closePopup()
    }
    
    func closePopup(){
        delegateDrawingViewController?.socketProvider?.emitClosePopupSelector(room: (delegateDrawingViewController?.room!)!)
        listenClose()
    }
    
    func listenClose(){
        dismiss(animated: true, completion: nil)
    }
    
}
