//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupTransitionCommand {

    func invoke(initialResults: CitySearchResults)
}

class StartupTransitionCommandNull : StartupTransitionCommand {

    func invoke(initialResults: CitySearchResults) {

    }
}

class StartupTransitionCommandImp : StartupTransitionCommand {

    private let window: UIWindow
    private let searchViewFactory: SearchViewFactory
    private let viewType: UIView.Type

    init(window: UIWindow, searchViewFactory: SearchViewFactory, viewType: UIView.Type) {

        self.window = window
        self.searchViewFactory = searchViewFactory
        self.viewType = viewType
    }

    func invoke(initialResults: CitySearchResults) {

        viewType.transition(with: window, duration: 1.0, options: UIView.AnimationOptions.transitionFlipFromRight, animations: { self.applyTransition(initialResults: initialResults) }, completion: nil)
    }

    private func applyTransition(initialResults: CitySearchResults) {

        let searchView = self.searchViewFactory.searchView(initialData: initialResults)
        let navigationController = UINavigationController(rootViewController: searchView)
        self.window.rootViewController = navigationController
    }
}