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

    func testOrientations() {

        let startupScreen = given.startupScreen()
        let landscapeOrientations = given.landscapeOrientations()

        when.startupScreenIsShown(startupScreen)

        then.startupScreen(startupScreen, supportedOrientationsAre: landscapeOrientations)
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
        let searchService = given.searchService()
        let startupScreen = given.startupScreen(transitionCommand: startupTransitionCommand, searchService: searchService)
        let maximumTransitionStartInterval = given.maximumTransitionStartInterval()
        let startupScreenLoadTime = given.startupScreenLoadedAtTime(startupScreen)
        given.searchServiceHasReturnedInitialResults(searchService)

        when.currentTimeIs(startupScreenLoadTime + maximumTransitionStartInterval)

        then.transitionToCitySearchScreenHasStarted()
    }

    func testTransitionDoesNotStartBeforeMinimumInterval() {

        let startupTransitionCommand = given.startupTransitionCommand()
        let searchService = given.searchService()
        let startupScreen = given.startupScreen(transitionCommand: startupTransitionCommand, searchService: searchService)
        let minimumTransitionStartInterval = given.minimumTransitionStartInterval()
        let startupScreenLoadTime = given.startupScreenLoadedAtTime(startupScreen)
        given.searchServiceHasReturnedInitialResults(searchService)

        when.currentTimeIs(startupScreenLoadTime + minimumTransitionStartInterval)

        then.transitionToCitySearchScreenHasNotStarted()
    }

    func testTransitionDoesNotStartBeforeResultsAreReady() {

        let startupTransitionCommand = given.startupTransitionCommand()
        let searchService = given.searchService()
        let startupScreen = given.startupScreen(transitionCommand: startupTransitionCommand, searchService: searchService)
        let maximumTransitionStartInterval = given.maximumTransitionStartInterval()
        let startupScreenLoadTime = given.startupScreenLoadedAtTime(startupScreen)

        when.currentTimeIs(startupScreenLoadTime + maximumTransitionStartInterval)

        then.transitionToCitySearchScreenHasNotStarted()
    }

    func testTransitionStartsWhenResultsAreReady() {

        let startupTransitionCommand = given.startupTransitionCommand()
        let searchService = given.searchService()
        let startupScreen = given.startupScreen(transitionCommand: startupTransitionCommand, searchService: searchService)
        let maximumTransitionStartInterval = given.maximumTransitionStartInterval()
        let resultsReceivedInterval = given.intervalGreaterThan(maximumTransitionStartInterval)
        let startupScreenLoadTime = given.startupScreenLoadedAtTime(startupScreen)
        given.searchService(searchService, returnsResultsAt: startupScreenLoadTime + resultsReceivedInterval)

        when.searchServiceReturnsInitialResults(searchService)

        then.transitionToCitySearchScreenHasStarted()
    }
}

class StartupScreenSteps {

    private let tests: XCTestCase
    private var transitionStarted = false

    private var servicePromise: CitySearchService.SearchFuture.Promise!

    private var resultsReturnedExpectation: XCTestExpectation?

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

    func searchServiceReturnsInitialResults(_ searchService: CitySearchServiceMock) {

        let expectation = tests.expectation(description: "Search results returned")

        self.resultsReturnedExpectation = expectation

        tests.wait(for: [expectation], timeout: 30.0)
    }

    func startupTransitionCommand() -> StartupTransitionCommandMock {

        let command = StartupTransitionCommandMock()

        command.invokeImp = {

            self.transitionStarted = true
        }

        return command
    }

    func searchService() -> CitySearchServiceMock {

        let searchService = CitySearchServiceMock()

        let serviceFuture = CitySearchService.SearchFuture({ promise in

            self.servicePromise = { results in

                promise(results)
                self.resultsReturnedExpectation?.fulfill()
            }
        })

        searchService.citySearchImp = { serviceFuture }

        return searchService
    }

    func maximumTransitionStartInterval() -> TimeInterval {

        StartupScreenTestConstants.maximumTransitionStartInterval
    }

    func minimumTransitionStartInterval() -> TimeInterval {

        StartupScreenTestConstants.minimumTransitionStartInterval
    }

    func intervalGreaterThan(_ interval: TimeInterval) -> TimeInterval {

        interval + 1.0
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

    func landscapeOrientations() -> UIInterfaceOrientationMask {

        UIInterfaceOrientationMask.landscape
    }

    func startupScreen(appTitleLabel: UILabel = UILabel(), transitionCommand: StartupTransitionCommandMock = StartupTransitionCommandMock(), searchService: CitySearchServiceMock = CitySearchServiceMock()) -> StartupViewImp {

        let builder = StartupViewBuilderImp()
        builder.appTitleLabel = appTitleLabel
        builder.transitionCommand = transitionCommand
        builder.searchService = searchService

        return builder.build()
    }

    func searchServiceHasReturnedInitialResults(_ searchService: CitySearchServiceMock) {

        servicePromise(.success(CitySearchResults.emptyResults()))
    }

    func searchService(_ searchService: CitySearchServiceMock, returnsResultsAt time: Date) {

        let timeToWait = time.timeIntervalSinceNow

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeToWait, execute: {

            self.servicePromise(.success(CitySearchResults.emptyResults()))
        })
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

    func startupScreen(_ startupScreen: StartupViewImp, supportedOrientationsAre expectedOrientations: UIInterfaceOrientationMask) {

        XCTAssertEqual(startupScreen.supportedInterfaceOrientations, expectedOrientations)
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