//
//  NameCreateScreenViewController.swift
//  Krakodil
//
//  Created by Nikita Gura on 29/10/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import UIKit

class NameCreateScreenViewController: UIViewController, Storyboarded{

    @IBOutlet weak var inputName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func creatNameAction(_ sender: Any) {
        if ( inputName.text?.count ?? 0 > 4) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(inputName.text ?? UserDefaultsNames.user_name, forKey: UserDefaultsNames.user_name)
            let roomsViewController = RoomsViewController.instantiate()
            roomsViewController.nickName = inputName.text
            navigationController?.pushViewController(roomsViewController, animated: true)
        }
    }
    
}
