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
    private let searchViewFactory: SearchViewFactory

    convenience override init() {

        self.init(startupViewBuilder: StartupViewBuilderImp(), searchViewFactory: SearchViewFactoryImp(), transitionCommandFactory: StartupTransitionCommandFactoryImp())
    }

    init(startupViewBuilder: StartupViewBuilder, searchViewFactory: SearchViewFactory, transitionCommandFactory: StartupTransitionCommandFactory) {

        self.searchViewFactory = searchViewFactory
        self.startupViewBuilder = startupViewBuilder
        self.transitionCommandFactory = transitionCommandFactory

        super.init()
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {

        let window = UIWindow()
        self.window = window

        let searchView = self.searchViewFactory.searchView(initialData: self.initialData())
        startupViewBuilder.transitionCommand = transitionCommandFactory.startupTransitionCommand(window: window, newRoot: searchView, viewType: UIView.self)

        window.makeKeyAndVisible()

        window.rootViewController = startupViewBuilder.build()
    }

    private func initialData() -> CitySearchResults {

        CitySearchResults(items: [
            CitySearchResult(name: "Test City 1"),
            CitySearchResult(name: "Test City 2"),
            CitySearchResult(name: "Test City 3"),
            CitySearchResult(name: "Test City 4"),
            CitySearchResult(name: "Test City 5")
        ])
    }
}
