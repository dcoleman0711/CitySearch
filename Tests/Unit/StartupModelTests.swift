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

    func testAppTitleTextIsAppTitle() {

        let appTitle = given.appTitle()
        let appTitleText = given.appTitleText()
        _ = given.model(appTitleText: appTitleText)

        then.appTitleText(appTitleText, textIs: appTitle)
    }

    func testBindAppTitleText() {

        let appTitleText = given.appTitleText()
        let model = given.model(appTitleText: appTitleText)
        let textUpdate = given.textUpdate()

        when.observerAppTitleText(model, textUpdate)

        then.textUpdateIsCalled(textUpdate)
    }

    func testScheduleTransitionTimer() {

        let model = given.model()
        let transitionStartInterval = given.transitionStartInterval()

        when.startTransitionTimer(model)

        then.timerIsScheduled(withInterval: transitionStartInterval)
    }
}

class StartupModelSteps {

    private var scheduledTimerInterval: TimeInterval?

    init() {

        TimerMock.scheduledTimerImp = { (interval, repeats, block) in

            self.scheduledTimerInterval = interval

            return TimerMock()
        }
    }

    func transitionStartInterval() -> TimeInterval {

        10.0
    }

    func startTransitionTimer(_ model: StartupModelImp) {

        model.startTransitionTimer()
    }

    func appTitle() -> String {

        StartupTestConstants.appTitle
    }

    private var textUpdateCalled = false

    func appTitleText() -> ObservableMock<String> {

        let appTitleText = ObservableMock<String>("")

        appTitleText.subscribeImp = { (listener, updateImmediately) in

            if updateImmediately {

                listener("")
            }
        }

        return appTitleText
    }

    func model(appTitleText: ObservableMock<String> = ObservableMock<String>("")) -> StartupModelImp {

        StartupModelImp(appTitleText: appTitleText, timerType: TimerMock.self)
    }

    func textUpdate() -> ValueUpdate<String> {

        { (text) in

            self.textUpdateCalled = true
        }
    }

    func observerAppTitleText(_ model: StartupModelImp, _ textUpdate: @escaping ValueUpdate<String>) {

        model.observeAppTitleText(textUpdate)
    }

    func appTitleText(_ text: ObservableMock<String>, textIs expectedText: String) {

        XCTAssertEqual(text.value, expectedText, "App Title Text value is not app title")
    }

    func textUpdateIsCalled(_ textUpdate: ValueUpdate<String>) {

        XCTAssertTrue(textUpdateCalled, "Text update was not called")
    }

    func timerIsScheduled(withInterval expectedInterval: TimeInterval) {

        XCTAssertEqual(scheduledTimerInterval, expectedInterval)
    }
}

class TimerMock: Timer {

    static var scheduledTimerImp: (_ interval: TimeInterval, _ repeats: Bool, _ block: @escaping (Timer) -> ()) -> Timer = { (interval, repeats, block) in TimerMock() }
    override class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> ()) -> Timer {

        scheduledTimerImp(interval, repeats, block)
    }
}