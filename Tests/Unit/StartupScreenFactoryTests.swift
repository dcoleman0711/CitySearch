//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class StartupScreenFactoryTests: BDDTest<StartupScreenFactorySteps> {

    func testFactoryPassesLabelToView() {

        let appTitleLabel = given.appTitleLabel()
        let startupViewFactory = given.startupViewFactory()
        let startupControllerFactory = given.startupControllerFactory(startupViewFactory)

        when.startupControllerFactoryCreatesStartupScreen(startupControllerFactory, appTitleLabel)

        then.appTitleLabelIsPassedToStartupViewFactory(appTitleLabel, startupViewFactory)
    }
}

final class StartupScreenFactorySteps: Steps {

    private var appTitleLabelPassedToStartupViewFactory: UILabel?

    func appTitleLabel() -> UILabel {

        UILabel()
    }

    func startupViewFactory() -> StartupViewFactoryMock {

        let startupViewFactory = StartupViewFactoryMock()
        startupViewFactory.startupViewImp = { (_ appTitleLabel: UILabel) -> StartupViewImp in

            self.appTitleLabelPassedToStartupViewFactory = appTitleLabel

            return StartupViewMock()
        }

        return startupViewFactory
    }

    func startupControllerFactory(_ startupViewFactory: StartupViewBuilder) -> StartupControllerFactory {

        StartupControllerFactory(startupViewFactory: startupViewFactory)
    }

    func startupControllerFactoryCreatesStartupScreen(_ startupControllerFactory: StartupControllerFactory, _ appTitleLabel: UILabel) {

        _ = startupControllerFactory.startupController(appTitleLabel: appTitleLabel)
    }

    func appTitleLabelIsPassedToStartupViewFactory(_ appTitleLabel: UILabel, _ startupViewFactory: StartupViewFactoryMock) {

        XCTAssertEqual(appTitleLabel, appTitleLabelPassedToStartupViewFactory, "App title label was not passed to view factory")
    }
}