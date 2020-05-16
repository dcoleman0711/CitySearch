//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class StartupViewBuilderMock: StartupViewBuilder {

    var transitionCommandSetter: (StartupTransitionCommand) -> Void = { (transitionCommand) in }
    var transitionCommand: StartupTransitionCommand { get { StartupTransitionCommandMock() } set { transitionCommandSetter(newValue) }}

    var buildImp: () -> StartupViewImp = { StartupViewBuilderImp().build() }
    func build() -> StartupViewImp {

        buildImp()
    }
}
