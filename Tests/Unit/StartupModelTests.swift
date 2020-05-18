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
        let model = given.modelIsCreated()
        let textUpdate = given.textUpdate()

        when.observerAppTitleText(model, textUpdate)

        then.appTitleTextIsUpdated(textUpdate, toValue: appTitle)
    }

    func testScheduleTransitionTimer() {

        let model = given.modelIsCreated()
        let transitionStartInterval = given.transitionStartInterval()

        when.transitionIsScheduled(model)

        then.timerIsScheduled(withInterval: transitionStartInterval)
    }

    func testTransitionTimerCallsTransitionCommandIfInitialResultsAreReady() {

        let searchService = given.searchService()
        let transitionCommand = given.transitionCommand()
        let model = given.modelIsCreated(transitionCommand: transitionCommand)
        given.transitionIsScheduled(model)
        given.searchServiceHasReturnedResults(searchService)

        when.transitionTimerFires()

        then.transitionCommandIsInvoked(transitionCommand)
    }

    func testRequestInitialResults() {

        let searchService = given.searchService()

        let model = when.modelIsCreated(searchService: searchService)

        then.searchServiceResultsWereRequested(searchService)
    }
}

class StartupModelSteps {

    private var serviceFuture: CitySearchService.SearchFuture!

    private var scheduledTimerInterval: TimeInterval?
    private var transitionCommandInvoked = false
    private var scheduledTimerBlock: ((Timer) -> Void)?

    private var observedAppTitleText: String?

    private var searchServiceThatReceivedRequest: CitySearchServiceMock?

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

    func modelIsCreated(transitionCommand: StartupTransitionCommandMock = StartupTransitionCommandMock(), searchService: CitySearchServiceMock = CitySearchServiceMock()) -> StartupModelImp {

        StartupModelImp(timerType: TimerMock.self, transitionCommand: transitionCommand, searchService: searchService)
    }

    func textUpdate() -> ValueUpdate<String> {

        { (text) in

            self.observedAppTitleText = text
        }
    }

    func observerAppTitleText(_ model: StartupModelImp, _ textUpdate: @escaping ValueUpdate<String>) {

        model.observeAppTitleText(textUpdate)
    }

    func transitionTimerFires() {

        scheduledTimerBlock?(TimerMock())
    }

    func searchService() -> CitySearchServiceMock {

        let searchService = CitySearchServiceMock()

        searchService.citySearchImp = {

            self.searchServiceThatReceivedRequest = searchService

            return self.serviceFuture
        }

        return searchService
    }

    func searchServiceHasReturnedResults(_ service: CitySearchServiceMock) {

        serviceFuture = CitySearchService.SearchFuture({ promise in

            promise(.success(CitySearchResults.emptyResults()))
        })
    }

    func appTitleTextIsUpdated(_ textUpdate: ValueUpdate<String>, toValue expectedText: String) {

        XCTAssertEqual(observedAppTitleText, expectedText, "App title text was not updated immediately")
    }

    func timerIsScheduled(withInterval expectedInterval: TimeInterval) {

        XCTAssertEqual(scheduledTimerInterval, expectedInterval)
    }

    func transitionCommandIsInvoked(_ transitionCommand: StartupTransitionCommandMock) {

        XCTAssertTrue(transitionCommandInvoked, "Transition command was not invoked")
    }

    func searchServiceResultsWereRequested(_ searchService: CitySearchServiceMock) {

        XCTAssertTrue(searchServiceThatReceivedRequest === searchService, "Search service did not receive initial results request")
    }
}

class TimerMock: Timer {

    static var scheduledTimerImp: (_ interval: TimeInterval, _ repeats: Bool, _ block: @escaping (Timer) -> ()) -> Timer = { (interval, repeats, block) in TimerMock() }
    override class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> ()) -> Timer {

        scheduledTimerImp(interval, repeats, block)
    }
}