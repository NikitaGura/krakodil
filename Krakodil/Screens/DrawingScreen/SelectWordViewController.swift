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
    var words = ["one", "two", "three"]
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstButton.setTitle(words[0], for: .normal)
        secondButton.setTitle(words[1], for: .normal)
        thirdButton.setTitle(words[2], for: .normal)
    }
    
    @IBAction func firstSelect(_ sender: Any) {
        delegateDrawingViewController?.selectWord = words[0]
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func secondSelect(_ sender: Any) {
        delegateDrawingViewController?.selectWord = words[1]
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func thirdSelect(_ sender: Any) {
        delegateDrawingViewController?.selectWord = words[2]
        dismiss(animated: true, completion: nil)
    }
    
}
