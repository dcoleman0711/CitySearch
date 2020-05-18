//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class StartupViewModelMock : StartupViewModel {

    var model: StartupModel = StartupModelMock()

    var observeAppTitleImp: (_ observer: @escaping ValueUpdate<LabelViewModel>) -> Void = { (observer) in }
    func observeAppTitle(_ observer: @escaping ValueUpdate<LabelViewModel>) {

        observeAppTitleImp(observer)
    }
}
