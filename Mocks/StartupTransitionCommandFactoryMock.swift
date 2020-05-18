//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class StartupTransitionCommandFactoryMock: StartupTransitionCommandFactory {

    var startupTransitionCommandImp: (_ window: UIWindow, _ searchViewFactory: SearchViewFactory, _ viewType: UIView.Type) -> StartupTransitionCommand = { (window, searchViewFactory, viewType) in StartupTransitionCommandMock() }
    func startupTransitionCommand(window: UIWindow, searchViewFactory: SearchViewFactory, viewType: UIView.Type) -> StartupTransitionCommand {

        startupTransitionCommandImp(window, searchViewFactory, viewType)
    }
}