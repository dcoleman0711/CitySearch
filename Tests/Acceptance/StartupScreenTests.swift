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
    
    func testBackgroundIsWhite() {

        let startupScreen = given.startupScreen()

        when.startupScreenIsShown(startupScreen)

        then.startupScreenBackgroundIsWhite(startupScreen)
    }
    
    func testAppTitleIsVisible() {

        let startupScreen = given.startupScreen()
        let appTitleLabel = given.appTitleLabel(startupScreen)

        when.startupScreenIsShown(startupScreen)

        then.appTitleIsVisible(startupScreen, appTitleLabel)
    }

    func testAppTitleWidth() {

        let screenSizes = given.screenSizes()

        for screenSize in screenSizes {

            testAppTitleWidth(screenSize: screenSize)
        }
    }

    func testAppTitleWidth(screenSize: CGSize) {

        let startupScreen = given.startupScreen()
        let appTitleLabel = given.appTitleLabel(startupScreen)
        given.startupScreenIsShown(startupScreen)

        when.startupScreenSizeBecomes(startupScreen, screenSize)
        
        then.appTitleLabel(appTitleLabel, widthIs: screenSize.width / 2.0)
    }

    func testAppTitleCenter() {

        let screenSizes = given.screenSizes()

        for screenSize in screenSizes {

            testAppTitleCenter(screenSize: screenSize)
        }
    }

    func testAppTitleCenter(screenSize: CGSize) {

        let startupScreen = given.startupScreen()
        let appTitleLabel = given.appTitleLabel(startupScreen)
        given.startupScreenIsShown(startupScreen)

        when.startupScreenSizeBecomes(startupScreen, screenSize)
        then.appTitleLabel(appTitleLabel, isCenteredIn: screenSize)
    }

    // In Progress
//    func testAppTitleText() {
//
//        let startupScreen = given.startupScreen()
//        let appTitleLabel = given.appTitleLabel(startupScreen)
//        let appTitleText = given.appTitleText()
//
//        when.startupScreenIsShown(startupScreen)
//
//        then.appTitleLabel(appTitleLabel, textIs: appTitleText)
//    }
}

class StartupScreenSteps {

    func appTitleText() -> String {

        "City Search"
    }

    func screenSizes() -> [CGSize] {

        [CGSize(width: 1024, height: 768), CGSize(width: 2048, height: 768), CGSize(width: 2048, height: 1536)]
    }

    func appTitleLabel(_ startupScreen: StartupController) -> UILabel {

        startupScreen.startupView.appTitleLabel
    }

    func startupScreen() -> StartupController {

        StartupController()
    }

    func startupScreenIsShown(_ startupScreen: StartupController) {

        startupScreen.loadViewIfNeeded()
    }

    func startupScreenSizeBecomes(_ startupScreen: StartupController, _ screenSize: CGSize) {

        startupScreen.view.frame = CGRect(origin: CGPoint.zero, size: screenSize)
        startupScreen.view.setNeedsLayout()
        startupScreen.view.layoutIfNeeded()
    }

    func startupScreenBackgroundIsWhite(_ startupScreen: StartupController) {

        XCTAssertEqual(startupScreen.view.backgroundColor, UIColor.white)
    }

    func appTitleIsVisible(_ startupScreen: StartupController, _ appTitleLabel: UILabel) {

        XCTAssertTrue(appTitleLabel.isDescendant(of: startupScreen.view), "App title is not visible on startup screen")
    }

    func appTitleLabel(_ appTitleLabel: UILabel, widthIs expectedWidth: CGFloat) {

        XCTAssertEqual(appTitleLabel.frame.size.width, expectedWidth, "App title center is not half the screen width")
    }

    func appTitleLabel(_ appTitleLabel: UILabel, isCenteredIn screenSize: CGSize) {

        XCTAssertEqual(appTitleLabel.center, CGPoint(x: screenSize.width / 2, y: screenSize.height / 2), "App title center is not screen center")
    }

    func appTitleLabel(_ appTitleLabel: UILabel, textIs expectedText: String) {

        XCTAssertEqual(appTitleLabel.text, expectedText)
    }

}
