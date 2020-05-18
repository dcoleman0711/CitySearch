//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class StartupModelTests: XCTestCase {

    var steps: StartupModelSteps!

    var given: StartupModelSteps { steps }
    var when: StartupModelSteps { steps }
    var then: StartupModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = StartupModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testObserveAppTitleText() {

        let appTitle = given.appTitle()
        let model = given.model()
        let textUpdate = given.textUpdate()

        when.observerAppTitleText(model, textUpdate)

        then.appTitleTextIsUpdated(textUpdate, toValue: appTitle)
    }

    func testScheduleTransitionTimer() {

        let model = given.model()
        let transitionStartInterval = given.transitionStartInterval()

        when.transitionIsScheduled(model)

        then.timerIsScheduled(withInterval: transitionStartInterval)
    }

    func testTransitionTimerCallsTransitionCommand() {

        let transitionCommand = given.transitionCommand()
        let model = given.model(transitionCommand: transitionCommand)
        given.transitionIsScheduled(model)

        when.transitionTimerFires()

        then.transitionCommandIsInvoked(transitionCommand)
    }
}

class StartupModelSteps {

    private var scheduledTimerInterval: TimeInterval?
    private var transitionCommandInvoked = false
    private var scheduledTimerBlock: ((Timer) -> Void)?

    private var observedAppTitleText: NSAttributedString?

    init() {

        TimerMock.scheduledTimerImp = { (interval, repeats, block) in

            self.scheduledTimerInterval = interval
            self.scheduledTimerBlock = block

            return TimerMock()
        }
    }

    func transitionStartInterval() -> TimeInterval {

        4.0
    }

    func transitionIsScheduled(_ model: StartupModelImp) {

        model.startTransitionTimer()
    }

    func transitionCommand() -> StartupTransitionCommandMock {

        let transitionCommand = StartupTransitionCommandMock()

        transitionCommand.invokeImp = {

            self.transitionCommandInvoked = true
        }

        return transitionCommand
    }

    func appTitle() -> String {

        StartupScreenTestConstants.appTitle
    }

    func model(transitionCommand: StartupTransitionCommandMock = StartupTransitionCommandMock()) -> StartupModelImp {

        StartupModelImp(timerType: TimerMock.self, transitionCommand: transitionCommand)
    }

    func textUpdate() -> ValueUpdate<NSAttributedString> {

        { (text) in

            self.observedAppTitleText = text
        }
    }

    func observerAppTitleText(_ model: StartupModelImp, _ textUpdate: @escaping ValueUpdate<NSAttributedString>) {

        model.observeAppTitleText(textUpdate)
    }

    func transitionTimerFires() {

        scheduledTimerBlock?(TimerMock())
    }

    func appTitleTextIsUpdated(_ textUpdate: ValueUpdate<NSAttributedString>, toValue expectedText: String) {

        XCTAssertEqual(observedAppTitleText?.string, expectedText, "App title text was not updated immediately")
    }

    func timerIsScheduled(withInterval expectedInterval: TimeInterval) {

        XCTAssertEqual(scheduledTimerInterval, expectedInterval)
    }

    func transitionCommandIsInvoked(_ transitionCommand: StartupTransitionCommandMock) {

        XCTAssertTrue(transitionCommandInvoked, "Transition command was not invoked")
    }
}

class TimerMock: Timer {

    static var scheduledTimerImp: (_ interval: TimeInterval, _ repeats: Bool, _ block: @escaping (Timer) -> ()) -> Timer = { (interval, repeats, block) in TimerMock() }
    override class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> ()) -> Timer {

        scheduledTimerImp(interval, repeats, block)
    }
}