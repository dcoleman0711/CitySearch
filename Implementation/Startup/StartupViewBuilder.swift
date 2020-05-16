//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupViewBuilder: class {

    var transitionCommand: StartupTransitionCommand { get set }

    func build() -> StartupViewImp
}

class StartupViewBuilderImp: StartupViewBuilder {

    var appTitleLabel = UILabel()
    var transitionCommand: StartupTransitionCommand = StartupTransitionCommandNull()

    func build() -> StartupViewImp {

        let model = StartupModelImp(appTitleText: Observable<String>(""), timerType: Timer.self, transitionCommand: transitionCommand)
        return StartupViewImp(appTitleLabel: appTitleLabel, model: model, binder: ViewBinderImp())
    }
}