//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol StartupViewFactory {

    func startupView(appTitleLabel: UILabel, startupModel: StartupModel, binder: ViewBinder) -> StartupView
}

class StartupViewFactoryImp : StartupViewFactory {

    func startupView(appTitleLabel: UILabel, startupModel: StartupModel, binder: ViewBinder) -> StartupView {

        startupViewImp(appTitleLabel: appTitleLabel, startupModel: startupModel, binder: binder)
    }

    func startupViewImp(appTitleLabel: UILabel, startupModel: StartupModel, binder: ViewBinder) -> StartupViewImp {

        StartupViewImp(appTitleLabel: appTitleLabel, model: startupModel, binder: binder)
    }
}
