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
    
    func testStartupScreenBackgroundIsWhite() {

        let startupScreen = given.startupScreen()

        when.startupScreenIsShown(startupScreen)

        then.startupScreenBackgroundIsWhite(startupScreen)
    }
    
    func testStartupScreenAppTitleIsVisible() {

        let startupScreen = given.startupScreen()
        let appTitleLabel = given.appTitleLabel(startupScreen)

        when.startupScreenIsShown(startupScreen)

        then.appTitleIsVisible(startupScreen, appTitleLabel)
    }
}

class StartupScreenSteps {

    func appTitleLabel(_ startupScreen: StartupController) -> UILabel {

        startupScreen.startupView.appTitleLabel
    }

    func startupScreen() -> StartupController {

        StartupController()
    }

    func startupScreenIsShown(_ startupScreen: StartupController) {

        startupScreen.loadViewIfNeeded()
    }

    func startupScreenBackgroundIsWhite(_ startupScreen: StartupController) {

        XCTAssertEqual(startupScreen.view.backgroundColor, UIColor.white)
    }

    func appTitleIsVisible(_ startupScreen: StartupController, _ appTitleLabel: UILabel) {

        XCTAssertTrue(appTitleLabel.isDescendant(of: startupScreen.view), "App title is not visible on startup screen")
    }
}
