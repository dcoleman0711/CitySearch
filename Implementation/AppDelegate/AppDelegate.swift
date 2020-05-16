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

    var window: UIWindow?

    private let startupViewBuilder: StartupViewBuilder
    private let transitionCommandFactory: StartupTransitionCommandFactory
    private let searchView: SearchViewImp

    convenience override init() {

        self.init(startupViewBuilder: StartupViewBuilderImp(), searchView: SearchViewImp(), transitionCommandFactory: StartupTransitionCommandFactoryImp())
    }

    init(startupViewBuilder: StartupViewBuilder, searchView: SearchViewImp, transitionCommandFactory: StartupTransitionCommandFactory) {

        self.searchView = searchView
        self.startupViewBuilder = startupViewBuilder
        self.transitionCommandFactory = transitionCommandFactory

        super.init()
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {

        let window = UIWindow()
        self.window = window

        startupViewBuilder.transitionCommand = transitionCommandFactory.startupTransitionCommand(window: window, newRoot: searchView, viewType: UIView.self)

        window.makeKeyAndVisible()

        window.rootViewController = startupViewBuilder.build()
    }
}
