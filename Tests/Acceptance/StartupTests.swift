//
// Created by Daniel Coleman on 5/15/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import Foundation
import UIKit

class StartupTestConstants {

    static let transitionDuration = 1.0
    static let transitionType = UIView.AnimationOptions.transitionFlipFromRight
}

class StartupTests : XCTestCase {
    
    var steps: StartupSteps!

    var given: StartupSteps { steps }
    var when: StartupSteps { steps }
    var then: StartupSteps { steps }

    override func setUp() {

        super.setUp()

        steps = StartupSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }
    
    func testShowStartupOnLaunch() {

        let app = given.application()

        when.appIsLaunched(app: app)

        then.startupScreenAppearsFullScreen(app: app)
    }

    func testTransitionToSearchView() {

        let startupView = given.startupView()
        let searchView = given.searchView()
        let transitionType = given.transitionType()
        let duration = given.transitionDuration()
        let app = given.application()
        given.appIsLaunched(app: app)

        when.transitionToSearchViewBegins()

        then.transition(ofType: transitionType, isAppliedFrom: startupView, to: searchView, with: duration)
    }
}

class StartupSteps {

    func transitionDuration() -> TimeInterval {

        StartupTestConstants.transitionDuration
    }

    private var startupViewStub = StartupViewBuilderImp().build()
    private let searchViewStub = SearchViewImp()

    private let transitionCommandFactory = StartupTransitionCommandFactoryMock()
    private var transitionCommand: StartupTransitionCommand?

    private var durationUsedInAnimation: TimeInterval?
    private var transitionTypeUsedInAnimation: UIView.AnimationOptions?
    private var transitionOldView: UIViewController?
    private var transitionNewView: UIViewController?

    init() {

        transitionCommandFactory.startupTransitionCommandImp = { (window, newRoot, viewType) in

            let transitionCommand = StartupTransitionCommandImp(window: window, newRoot: newRoot, viewType: UIViewMock.self)
            self.transitionCommand = transitionCommand
            return transitionCommand
        }
    }

    func application() -> AppDelegate {

        let startupViewBuilder = StartupViewBuilderMock()

        startupViewBuilder.buildImp = { self.startupViewStub }

        let app = AppDelegate(startupViewBuilder: startupViewBuilder, searchView: searchViewStub, transitionCommandFactory: transitionCommandFactory)

        UIViewMock.transitionImp = { (view, duration, options, animations, completion) in

            if view == app.window {

                self.durationUsedInAnimation = duration
                self.transitionTypeUsedInAnimation = options.intersection([UIView.AnimationOptions.transitionFlipFromRight])

                self.transitionOldView = app.window?.rootViewController
                animations?()
                self.transitionNewView = app.window?.rootViewController
            }
        }

        return app
    }

    func startupView() -> StartupViewImp {

        startupViewStub
    }

    func searchView() -> SearchViewImp {

        searchViewStub
    }

    func transitionType() -> UIView.AnimationOptions {

        StartupTestConstants.transitionType
    }

    func appIsLaunched(app: AppDelegate) {

        app.applicationDidFinishLaunching(UIApplication.shared)
    }

    func transitionToSearchViewBegins() {

        transitionCommand?.invoke()
    }

    func startupScreenAppearsFullScreen(app: AppDelegate) {

        guard let window = app.window else {
            XCTFail("AppDelegate window is nil")
            return
        }

        XCTAssertTrue(window.isKeyWindow, "AppDelegate window is not key window")

        guard let rootController = window.rootViewController else {
            XCTFail("Application window does not have root view controller after launch")
            return
        }

        XCTAssertTrue(rootController is StartupViewImp, "Root controller's is not Startup Screen")
    }

    func transition(ofType expectedTransitionType: UIView.AnimationOptions, isAppliedFrom expectedOldView: UIViewController, to expectedNewView: UIViewController, with expectedDuration: TimeInterval) {

        XCTAssertEqual(durationUsedInAnimation, expectedDuration)
        XCTAssertEqual(transitionTypeUsedInAnimation, expectedTransitionType)
        XCTAssertEqual(transitionOldView, expectedOldView)
        XCTAssertEqual(transitionNewView, expectedNewView)
    }
}

class UIViewMock: UIView {

    static var transitionImp: (_ view: UIView, _ duration: TimeInterval, _ options: UIView.AnimationOptions, _ animations: (() -> Void)?, _ completion: ((Bool) -> Void)?) -> Void = { (view, duration, options, animations, completion) in }
    override class func transition(with view: UIView, duration: TimeInterval, options: UIView.AnimationOptions = [], animations: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {

        transitionImp(view, duration, options, animations, completion)
    }
}