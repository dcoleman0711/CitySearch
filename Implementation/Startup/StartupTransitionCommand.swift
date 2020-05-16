//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupTransitionCommand {

    func invoke()
}

class StartupTransitionCommandNull : StartupTransitionCommand {

    func invoke() {

    }
}

class StartupTransitionCommandImp : StartupTransitionCommand {

    private let window: UIWindow
    private let newRoot: UIViewController
    private let viewType: UIView.Type

    init(window: UIWindow, newRoot: UIViewController, viewType: UIView.Type) {

        self.window = window
        self.newRoot = newRoot
        self.viewType = viewType
    }

    func invoke() {

        viewType.transition(with: window, duration: 1.0, options: UIView.AnimationOptions.transitionFlipFromRight, animations: { self.window.rootViewController = self.newRoot }, completion: nil)
    }
}