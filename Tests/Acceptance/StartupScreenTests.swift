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
//        let startupScreen = given.startupScreen()
//        let appTitleLabel = given.appTitleLabel(startupScreen)
//
//        when.startupScreenIsShown(startupScreen)
//
//        then.appTitleIsVisible(startupScreen, appTitleLabel)
//    }
}

final class StartupScreenSteps: Steps {

    func appTitleLabel(_ startupScreen: StartupController) -> UILabel {

        startupScreen.startupView.appTitleLabel
    }

    func startupScreen() -> StartupController {

        StartupController()
    }

    func startupScreenIsShown(_ startupScreen: StartupController) {

        startupScreen.loadViewIfNeeded()
    }

    func appTitleIsVisible(_ startupScreen: StartupController, _ appTitleLabel: UILabel) {

        XCTAssertTrue(appTitleLabel.isDescendant(of: startupScreen.view), "App title is not visible on startup screen")
    }
}
