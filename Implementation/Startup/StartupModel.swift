//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol StartupModel {

    func observeAppTitleText(_ update: @escaping ValueUpdate<NSAttributedString>)

    func startTransitionTimer()
}

class StartupModelImp: StartupModel {

    private let appTitleText: NSAttributedString
    private let timerType: Timer.Type
    private let transitionCommand: StartupTransitionCommand

    init(timerType: Timer.Type, transitionCommand: StartupTransitionCommand) {

        self.appTitleText = NSAttributedString(string: "City Search")
        self.timerType = timerType

        self.transitionCommand = transitionCommand
    }

    func observeAppTitleText(_ update: @escaping ValueUpdate<NSAttributedString>) {

        update(appTitleText)
    }

    func startTransitionTimer() {

        self.timerType.scheduledTimer(withTimeInterval: 4.0, repeats: false, block: StartupModelImp.fireTransitionTimer(self))
    }

    private func fireTransitionTimer(timer: Timer) {

        transitionCommand.invoke()
    }
}