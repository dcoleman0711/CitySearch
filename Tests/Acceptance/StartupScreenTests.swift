//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

@testable import CitySearch

import UIKit

class StartupScreenTests: BDDTest<StartupScreenSteps> {
    
    // In-Progress
//    func testStartupScreenAppTitleIsVisible() {
//
//        let appTitleLabel = given.appTitleLabel()
//        let startupScreen = given.startupScreen(appTitleLabel: appTitleLabel)
//
//        when.startupScreenIsShown(startupScreen)
//
//        then.appTitleIsVisible(startupScreen, appTitleLabel)
//    }
}

final class StartupScreenSteps: Steps {

    func appTitleLabel() -> UILabel {

        UILabel()
    }

    func startupScreen(appTitleLabel: UILabel) -> StartupController {

        let factory = StartupControllerFactory(appTitleLabel: appTitleLabel)

        return factory.startupController()
    }

    func startupScreenIsShown(_ startupScreen: StartupController) {

        startupScreen.loadViewIfNeeded()
    }

    func appTitleIsVisible(_ startupScreen: StartupController, _ appTitleLabel: UILabel) {

        XCTAssertTrue(appTitleLabel.isDescendant(of: startupScreen.view), "App title is not visible on startup screen")
    }
}
