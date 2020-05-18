//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class StartupModelMock : StartupModel {

    var observeAppTitleTextImp: (_ update: @escaping ValueUpdate<NSAttributedString>) -> Void = { (update) in }
    func observeAppTitleText(_ update: @escaping ValueUpdate<NSAttributedString>) {

        observeAppTitleTextImp(update)
    }

    var startTransitionTimerImp: () -> Void = { }
    func startTransitionTimer() {

        startTransitionTimerImp()
    }
}
