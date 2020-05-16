//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol StartupModel {

    func observeAppTitleText(_ update: @escaping ValueUpdate<String>)
}

class StartupModelImp: StartupModel {

    private let appTitleText: Observable<String>

    convenience init() {

        self.init(appTitleText: Observable<String>())
    }

    init(appTitleText: Observable<String>) {

        self.appTitleText = appTitleText
    }

    func observeAppTitleText(_ update: @escaping ValueUpdate<String>) {

        appTitleText.subscribe(update, updateImmediately: true)
    }
}