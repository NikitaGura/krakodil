//
//  AppDelegate.swift
//  Krakodil
//
//  Created by Nikita Gura on 11/5/19.
//  Copyright © 2019 Nikita Gura. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var initScreen: UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        
        let userDefaults = UserDefaults.standard
        if let nickName = userDefaults.string(forKey: UserDefaultsNames.user_name){
            let roomScreen = RoomsViewController.instantiate()
            roomScreen.nickName = nickName
            initScreen = UINavigationController(rootViewController: roomScreen)
        } else {
            initScreen =  UINavigationController(rootViewController: NameCreateScreenViewController.instantiate())
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = initScreen
        window?.makeKeyAndVisible()
            
        return true
    }
    
  
    
}

