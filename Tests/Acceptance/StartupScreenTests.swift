//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class StartupScreenTestConstants {

    static let appTitle = "City Search"
    static let appTitleFont = UIFont.systemFont(ofSize: 48.0)
    static let maximumTransitionStartInterval = 4.5
    static let minimumTransitionStartInterval = 3.5
}

class StartupScreenTests: XCTestCase {
    
    var steps: StartupScreenSteps!

    var given: StartupScreenSteps { steps }
    var when: StartupScreenSteps { steps }
    var then: StartupScreenSteps { steps }

    override func setUp() {

        super.setUp()

        steps = StartupScreenSteps(self)
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

        let appTitleLabel = given.appTitleLabel()
        let startupScreen = given.startupScreen(appTitleLabel: appTitleLabel)

        when.startupScreenIsShown(startupScreen)

        then.appTitleIsVisible(startupScreen, appTitleLabel)
    }

    func testAppTitleCenter() {

        let screenSizes = given.screenSizes()

        for screenSize in screenSizes {

            testAppTitleCenter(screenSize: screenSize)
        }
    }

    func testAppTitleCenter(screenSize: CGSize) {

        let appTitleLabel = given.appTitleLabel()
        let startupScreen = given.startupScreen(appTitleLabel: appTitleLabel)
        given.startupScreenIsShown(startupScreen)

        when.startupScreenSizeBecomes(startupScreen, screenSize)
        then.appTitleLabel(appTitleLabel, isCenteredIn: screenSize)
    }

    func testAppTitleSize() {

        let screenSizes = given.screenSizes()

        for screenSize in screenSizes {

            testAppTitleSize(screenSize: screenSize)
        }
    }

    func testAppTitleSize(screenSize: CGSize) {

        let appTitleLabel = given.appTitleLabel()
        let startupScreen = given.startupScreen(appTitleLabel: appTitleLabel)
        given.startupScreenIsShown(startupScreen)

        when.startupScreenSizeBecomes(startupScreen, screenSize)
        then.appTitleLabelSizeFitsText(appTitleLabel)
    }
    
    func testAppTitleText() {

        let appTitleLabel = given.appTitleLabel()
        let startupScreen = given.startupScreen(appTitleLabel: appTitleLabel)
        let appTitleText = given.appTitleText()

        when.startupScreenIsShown(startupScreen)

        then.appTitleLabel(appTitleLabel, textIs: appTitleText)
    }

    func testAppTitleFont() {

        let appTitleLabel = given.appTitleLabel()
        let startupScreen = given.startupScreen(appTitleLabel: appTitleLabel)
        let appTitleFont = given.appTitleFont()

        when.startupScreenIsShown(startupScreen)

        then.appTitleLabel(appTitleLabel, fontIs: appTitleFont)
    }

    func testTransitionStartsBeforeMaximumInterval() {

        let startupTransitionCommand = given.startupTransitionCommand()
        let startupScreen = given.startupScreen(transitionCommand: startupTransitionCommand)
        let maximumTransitionStartInterval = given.maximumTransitionStartInterval()
        let startupScreenLoadTime = given.startupScreenLoadedAtTime(startupScreen)

        when.currentTimeIs(startupScreenLoadTime + maximumTransitionStartInterval)

        then.transitionToCitySearchScreenHasStarted()
    }

    func testTransitionDoesNotStartBeforeMinimumInterval() {

        let startupTransitionCommand = given.startupTransitionCommand()
        let startupScreen = given.startupScreen(transitionCommand: startupTransitionCommand)
        let minimumTransitionStartInterval = given.minimumTransitionStartInterval()
        let startupScreenLoadTime = given.startupScreenLoadedAtTime(startupScreen)

        when.currentTimeIs(startupScreenLoadTime + minimumTransitionStartInterval)

        then.transitionToCitySearchScreenHasNotStarted()
    }
}

class StartupScreenSteps {

    private let tests: XCTestCase
    private var transitionStarted = false

    init(_ tests: XCTestCase) {

        self.tests = tests
    }

    func currentTimeIs(_ time: Date) {

        let timeToWait = time.timeIntervalSinceNow

        let expectation = tests.expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeToWait, execute: {

            expectation.fulfill()
        })

        tests.wait(for: [expectation], timeout: 30.0)
    }

    func startupTransitionCommand() -> StartupTransitionCommandMock {

        let command = StartupTransitionCommandMock()

        command.invokeImp = {

            self.transitionStarted = true
        }

        return command
    }

    func maximumTransitionStartInterval() -> TimeInterval {

        StartupScreenTestConstants.maximumTransitionStartInterval
    }

    func minimumTransitionStartInterval() -> TimeInterval {

        StartupScreenTestConstants.minimumTransitionStartInterval
    }

    func startupScreenLoadedAtTime(_ startupScreen: StartupViewImp) -> Date {

        startupScreen.loadViewIfNeeded()
        return Date()
    }

    func appTitleFont() -> UIFont {

        StartupScreenTestConstants.appTitleFont
    }

    func appTitleText() -> String {

        StartupScreenTestConstants.appTitle
    }

    func screenSizes() -> [CGSize] {

        [CGSize(width: 1024, height: 768), CGSize(width: 2048, height: 768), CGSize(width: 2048, height: 1536)]
    }

    func appTitleLabel() -> UILabel {

        UILabel()
    }

    func startupScreen(appTitleLabel: UILabel = UILabel(), transitionCommand: StartupTransitionCommandMock = StartupTransitionCommandMock()) -> StartupViewImp {

        let builder = StartupViewBuilderImp()
        builder.appTitleLabel = appTitleLabel
        builder.transitionCommand = transitionCommand

        return builder.build()
    }

    func startupScreenIsShown(_ startupScreen: StartupViewImp) {

        startupScreen.loadViewIfNeeded()
    }

    func startupScreenSizeBecomes(_ startupScreen: StartupViewImp, _ screenSize: CGSize) {

        startupScreen.view.frame = CGRect(origin: CGPoint.zero, size: screenSize)
        startupScreen.view.setNeedsLayout()
        startupScreen.view.layoutIfNeeded()
    }

    func startupScreenBackgroundIsWhite(_ startupScreen: StartupViewImp) {

        XCTAssertEqual(startupScreen.view.backgroundColor, UIColor.white)
    }

    func appTitleIsVisible(_ startupScreen: StartupViewImp, _ appTitleLabel: UILabel) {

        XCTAssertTrue(appTitleLabel.isDescendant(of: startupScreen.view), "App title is not visible on startup screen")
    }

    func appTitleLabel(_ appTitleLabel: UILabel, isCenteredIn screenSize: CGSize) {

        // The values aren't exact when the size of the view is non-integer.  We need to round down
        XCTAssertEqual(CGPoint(x: floor(appTitleLabel.center.x), y: floor(appTitleLabel.center.y)), CGPoint(x: screenSize.width / 2, y: screenSize.height / 2), "App title center is not screen center")
    }

    func appTitleLabel(_ appTitleLabel: UILabel, textIs expectedText: String) {

        XCTAssertEqual(appTitleLabel.text, expectedText, "App title text is not app title")
    }

    func appTitleLabelSizeFitsText(_ appTitleLabel: UILabel) {

        XCTAssertEqual(appTitleLabel.frame.size, appTitleLabel.sizeThatFits(CGSize.zero), "App title size does not fit text")
    }

    func appTitleLabel(_ appTitleLabel: UILabel, fontIs font: UIFont) {

        XCTAssertEqual(appTitleLabel.font, font, "App title font is not correct")
    }

    func transitionToCitySearchScreenHasStarted() {

        XCTAssertTrue(transitionStarted, "Transition to search screen has not started")
    }

    func transitionToCitySearchScreenHasNotStarted() {

        XCTAssertFalse(transitionStarted, "Transition to search screen has already started")
    }
}