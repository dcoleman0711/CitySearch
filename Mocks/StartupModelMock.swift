//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class StartupModelMock : StartupModel {

    var observeAppTitleTextImp: (_ update: @escaping ValueUpdate<String>) -> Void = { (update) in }
    func observeAppTitleText(_ update: @escaping ValueUpdate<String>) {

        observeAppTitleTextImp(update)
    }
}
