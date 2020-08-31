//
//  AppDelegate.swift
//  SafeKeyboard
//
//  Created by hunter.liu on 2020/4/23.
//  Copyright © 2020 com.jh.testkeyboard. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private weak var coverVC: CoverViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let _ = CoverWindow.shared
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
//        let coverVC = CoverViewController()
//        self.coverVC = coverVC
//        window?.rootViewController?.present(coverVC, animated: false, completion: nil)
        CoverWindow.shared.show()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        coverVC?.dismiss(animated: false, completion: nil)
        CoverWindow.shared.hide()
    }
    
}

