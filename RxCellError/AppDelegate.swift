//
//  AppDelegate.swift
//  RxCellError
//
//  Created by Rezuan Bidzhiev on 16.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = ViewController()
    window?.makeKeyAndVisible()
    
    return true
  }

}

