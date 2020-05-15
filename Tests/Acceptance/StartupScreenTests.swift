//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

@testable import CitySearch

import UIKit

class StartupScreenTests: XCTestCase {

    var steps: StartupScreenSteps!

    var given: StartupScreenSteps { steps }
    var when: StartupScreenSteps { steps }
    var then: StartupScreenSteps { steps }

    override func setUp() {

        super.setUp()

        steps = StartupScreenSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

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

class StartupScreenSteps {

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
