//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupTransitionCommandFactory {

    func startupTransitionCommand(window: UIWindow, searchViewFactory: SearchViewFactory, viewType: UIView.Type) -> StartupTransitionCommand
}

class StartupTransitionCommandFactoryImp: StartupTransitionCommandFactory {

    func startupTransitionCommand(window: UIWindow, searchViewFactory: SearchViewFactory, viewType: UIView.Type) -> StartupTransitionCommand {

        StartupTransitionCommandImp(window: window, searchViewFactory: searchViewFactory, viewType: viewType)
    }
}