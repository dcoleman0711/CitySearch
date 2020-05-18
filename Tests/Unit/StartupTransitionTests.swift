////
//// Created by Daniel Coleman on 5/16/20.
//// Copyright (c) 2020 Daniel Coleman. All rights reserved.
////

import XCTest

import Foundation
import UIKit

class StartupTransitionTests : XCTestCase {

    var steps: StartupTransitionSteps!

    var given: StartupTransitionSteps { steps }
    var when: StartupTransitionSteps { steps }
    var then: StartupTransitionSteps { steps }

    override func setUp() {

        super.setUp()

        steps = StartupTransitionSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTransitionAppliedOnWindow() {

        let window = given.window()
        let transitionCommand = given.transitionCommand(window: window)

        when.transitionCommandIsInvoked(transitionCommand)

        then.transitionIsAppliedOn(window)
    }

    func testTransitionDuration() {

        let duration = given.duration()
        let transitionCommand = given.transitionCommand()

        when.transitionCommandIsInvoked(transitionCommand)

        then.transitionDurationIs(duration)
    }

    func testTransitionType() {

        let transitionType = given.transitionType()
        let transitionCommand = given.transitionCommand()

        when.transitionCommandIsInvoked(transitionCommand)

        then.transitionTypeIs(transitionType)
    }

    func testTransitionRootBeforeAnimations() {

        let window = given.window()
        let oldRoot = given.windowRoot(window)
        let transitionCommand = given.transitionCommand(window: window)

        when.transitionCommandIsInvoked(transitionCommand)

        then.rootOfWindow(window, isSetTo: oldRoot)
    }

    func testTransitionRootAfterAnimations() {

        let window = given.window()
        let searchViewFactory = given.searchViewFactory()
        let searchView = given.searchView(createdBy: searchViewFactory)
        let transitionCommand = given.transitionCommand(window: window, searchViewFactory: searchViewFactory)
        given.transitionCommandIsInvoked(transitionCommand)

        when.performTransitionAnimations()

        then.rootOfWindow(window, isNavigationStackContaining: searchView)
    }

    func testTransitionInitialData() {

        let window = given.window()
        let initialResults = given.initialResults()
        let searchViewFactory = given.searchViewFactory()
        let searchView = given.searchView(createdBy: searchViewFactory)
        let transitionCommand = given.transitionCommand(window: window, searchViewFactory: searchViewFactory)
        given.transitionCommand(transitionCommand, isInvokedWith: initialResults)

        when.performTransitionAnimations()

        then.searchView(searchView, isCreatedWith: initialResults)
    }
}

class StartupTransitionSteps {

    private var transitionTypeUsed: UIView.AnimationOptions = []
    private var transitionDuration: TimeInterval?
    private var transitionView: UIView!

    private var transitionAnimations: (() -> Void)?

    private var initialResultsPassedToSearchView: CitySearchResults?

    init() {

        UIViewMock.transitionImp = { (view, duration, options, animations, completion) in

            self.transitionView = view
            self.transitionDuration = duration
            self.transitionTypeUsed = options
            self.transitionAnimations = animations
        }
    }

    func transitionType() -> UIView.AnimationOptions {

        StartupTestConstants.transitionType
    }

    func duration() -> TimeInterval {

        StartupTestConstants.transitionDuration
    }

    func window() -> UIWindow {

        UIWindow()
    }

    func searchViewFactory() -> SearchViewFactoryMock {

        SearchViewFactoryMock()
    }

    func transitionCommand(window: UIWindow = UIWindow(), searchViewFactory: SearchViewFactoryMock = SearchViewFactoryMock()) -> StartupTransitionCommandImp {

        StartupTransitionCommandFactoryImp().startupTransitionCommand(window: window, searchViewFactory: searchViewFactory, viewType: UIViewMock.self) as! StartupTransitionCommandImp
    }

    func windowRoot(_ window: UIWindow) -> UIViewController {

        let root = UIViewController()
        window.rootViewController = root
        return root
    }

    func initialResults() -> CitySearchResults {

        CitySearchResultsStub.stubResults()
    }

    func transitionCommandIsInvoked(_ command: StartupTransitionCommandImp) {

        command.invoke(initialResults: CitySearchResults.emptyResults())
    }

    func performTransitionAnimations() {

        transitionAnimations?()
    }

    func searchView(createdBy factory: SearchViewFactoryMock) -> SearchViewImp {

        let searchView = SearchViewImp()

        factory.searchViewImp = { initialData in

            self.initialResultsPassedToSearchView = initialData
            return searchView
        }

        return searchView
    }

    func transitionCommand(_ transitionCommand: StartupTransitionCommandImp, isInvokedWith initialResults: CitySearchResults) {

        transitionCommand.invoke(initialResults: initialResults)
    }

    func transitionIsAppliedOn(_ window: UIWindow) {

        XCTAssertEqual(transitionView, window, "Transition is not on window")
    }

    func transitionDurationIs(_ expectedDuration: TimeInterval) {

        XCTAssertEqual(transitionDuration, expectedDuration, "Transition duration is not correct")
    }

    func transitionTypeIs(_ expectedType: UIView.AnimationOptions) {

        XCTAssertTrue(transitionTypeUsed.contains(expectedType), "Transition type is not correct")
    }

    func rootOfWindow(_ window: UIWindow, isSetTo expectedNewRoot: UIViewController) {

        XCTAssertEqual(window.rootViewController, expectedNewRoot, "Window root is not expected root")
    }

    func rootOfWindow(_ window: UIWindow, isNavigationStackContaining expectedNewRoot: UIViewController) {

        guard let navigationController = window.rootViewController as? UINavigationController else {
            XCTFail("Window root is not navigation controller")
            return
        }

        XCTAssertEqual(navigationController.viewControllers, [expectedNewRoot], "Navigation stack is not the expected root")
    }

    func searchView(_ searchView: SearchViewImp, isCreatedWith expectedResults: CitySearchResults) {

        XCTAssertEqual(initialResultsPassedToSearchView, expectedResults, "Search view was not created with initial results")
    }
}