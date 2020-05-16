//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupTransitionCommandFactory {

    func startupTransitionCommand(window: UIWindow, newRoot: UIViewController, viewType: UIView.Type) -> StartupTransitionCommand
}

class StartupTransitionCommandFactoryImp: StartupTransitionCommandFactory {

    func startupTransitionCommand(window: UIWindow, newRoot: UIViewController, viewType: UIView.Type) -> StartupTransitionCommand {

        startupTransitionCommandImp(window: window, newRoot: newRoot, viewType: viewType)
    }

    func startupTransitionCommandImp(window: UIWindow, newRoot: UIViewController, viewType: UIView.Type) -> StartupTransitionCommandImp {

        StartupTransitionCommandImp(window: window, newRoot: newRoot, viewType: viewType)
    }
}