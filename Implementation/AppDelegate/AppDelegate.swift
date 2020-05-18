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

        self.init(startupViewBuilder: StartupViewBuilderImp(), searchViewFactory: SearchViewFactoryImp(), searchService: CitySearchServiceImp(), transitionCommandFactory: StartupTransitionCommandFactoryImp())
    }

    init(startupViewBuilder: StartupViewBuilder, searchViewFactory: SearchViewFactory, searchService: CitySearchService, transitionCommandFactory: StartupTransitionCommandFactory) {

        self.searchViewFactory = searchViewFactory
        self.startupViewBuilder = startupViewBuilder
        self.transitionCommandFactory = transitionCommandFactory

        super.init()

        self.startupViewBuilder.searchService = searchService
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {

        let window = UIWindow()
        self.window = window

        let searchView = self.searchViewFactory.searchView(initialData: CitySearchResults.emptyResults())
        startupViewBuilder.transitionCommand = transitionCommandFactory.startupTransitionCommand(window: window, newRoot: searchView, viewType: UIView.self)

        window.makeKeyAndVisible()

        window.rootViewController = startupViewBuilder.build()
    }
}
