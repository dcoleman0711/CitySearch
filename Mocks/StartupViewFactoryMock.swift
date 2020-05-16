//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class StartupViewFactoryMock: StartupViewFactory {

    var startupViewImp: (_ appTitleLabel: UILabel, _ startupModel: StartupModel, _ binder: ViewBinder) -> StartupView = { (appTitleLabel, startupModel, binder) in StartupViewMock() }
    func startupView(appTitleLabel: UILabel, startupModel: StartupModel, binder: ViewBinder) -> StartupView {

        startupViewImp(appTitleLabel, startupModel, binder)
    }
}
