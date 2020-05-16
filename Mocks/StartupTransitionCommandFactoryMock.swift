//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class StartupTransitionCommandFactoryMock: StartupTransitionCommandFactory {

    var startupTransitionCommandImp: (_ window: UIWindow, _ newRoot: UIViewController, _ viewType: UIView.Type) -> StartupTransitionCommand = { (window, newRoot, viewType) in StartupTransitionCommandMock() }
    func startupTransitionCommand(window: UIWindow, newRoot: UIViewController, viewType: UIView.Type) -> StartupTransitionCommand {

        startupTransitionCommandImp(window, newRoot, viewType)
    }
}