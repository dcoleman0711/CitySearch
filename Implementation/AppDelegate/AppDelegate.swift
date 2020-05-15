//
//  AppDelegate.swift
//  CitySearch
//
//  Created by Daniel Coleman on 5/14/20.
//  Copyright © 2020 Daniel Coleman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate : NSObject, UIApplicationDelegate {

    let window = UIWindow()

    func applicationDidFinishLaunching(_ application: UIApplication) {

        window.makeKeyAndVisible()

        window.rootViewController = StartupController()
    }
}