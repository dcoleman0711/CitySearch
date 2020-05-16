//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol StartupModel {

    func observeAppTitleText(_ update: @escaping ValueUpdate<String>)

    func startTransitionTimer()
}

class StartupModelImp: StartupModel {

    private let appTitleText: Observable<String>
    private let timerType: Timer.Type

    convenience init() {

        self.init(appTitleText: Observable<String>(""), timerType: Timer.self)
    }

    init(appTitleText: Observable<String>, timerType: Timer.Type) {

        self.appTitleText = appTitleText
        self.timerType = timerType

        self.appTitleText.value = "City Search"
    }

    func observeAppTitleText(_ update: @escaping ValueUpdate<String>) {

        appTitleText.subscribe(update, updateImmediately: true)
    }

    func startTransitionTimer() {

        self.timerType.scheduledTimer(withTimeInterval: 10.0, repeats: false) { timer in  }
    }
}