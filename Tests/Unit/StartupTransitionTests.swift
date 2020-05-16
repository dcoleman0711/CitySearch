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
        let newRoot = given.newRoot()
        let transitionCommand = given.transitionCommand(window: window, newRoot: newRoot)
        given.transitionCommandIsInvoked(transitionCommand)

        when.performTransitionAnimations()

        then.rootOfWindow(window, isSetTo: newRoot)
    }
}

class StartupTransitionSteps {

    private var transitionTypeUsed: UIView.AnimationOptions = []
    private var transitionDuration: TimeInterval?
    private var transitionView: UIView!

    private var transitionAnimations: (() -> Void)?

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

    func newRoot() -> UIViewController {

        UIViewController()
    }

    func transitionCommand(window: UIWindow = UIWindow(), newRoot: UIViewController = UIViewController()) -> StartupTransitionCommandImp {

        StartupTransitionCommandFactoryImp().startupTransitionCommandImp(window: window, newRoot: newRoot, viewType: UIViewMock.self)
    }

    func windowRoot(_ window: UIWindow) -> UIViewController {

        let root = UIViewController()
        window.rootViewController = root
        return root
    }

    func transitionCommandIsInvoked(_ command: StartupTransitionCommandImp) {

        command.invoke()
    }

    func performTransitionAnimations() {

        transitionAnimations?()
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

        XCTAssertEqual(window.rootViewController, expectedNewRoot)
    }
}
