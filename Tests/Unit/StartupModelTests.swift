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
        let initialResults = given.initialResults(from: searchService)
        let transitionCommand = given.transitionCommand()
        let invocationQueue = given.invocationQueue()
        let model = given.modelIsCreated(transitionCommand: transitionCommand, searchService: searchService)
        given.transitionIsScheduled(model)
        given.searchServiceHasReturnedResults(searchService)

        when.transitionTimerFires()

        then.transitionCommand(transitionCommand, isInvokedWith: initialResults, onQueue: invocationQueue)
    }

    func testTransitionTimerDoesNotCallTransitionCommandIfInitialResultsAreNotReady() {

        let searchService = given.searchService()
        let transitionCommand = given.transitionCommand()
        let model = given.modelIsCreated(transitionCommand: transitionCommand, searchService: searchService)
        given.transitionIsScheduled(model)

        when.transitionTimerFires()

        then.transitionCommandIsNotInvoked(transitionCommand)
    }

    func testRequestInitialResults() {

        let searchService = given.searchService()

        let model = when.modelIsCreated(searchService: searchService)

        then.searchServiceResultsWereRequested(searchService)
    }
}

class StartupModelSteps {

    private let initialResults = CitySearchResultsStub.stubResults()

    private let invocationQueueMock = DispatchQueueMock()

    private var serviceFuture: CitySearchService.SearchFuture!

    private var scheduledTimerInterval: TimeInterval?
    private var transitionCommandInvocationData: CitySearchResults? = nil
    private var scheduledTimerBlock: ((Timer) -> Void)?

    private var observedAppTitleText: String?

    private var searchServiceThatReceivedRequest: CitySearchServiceMock?

    private var servicePromise: CitySearchService.SearchFuture.Promise!

    private var isOnInvocationQueue = false
    private var transitionCommandInvokedOnQueue = false

    init() {

        TimerMock.scheduledTimerImp = { (interval, repeats, block) in

            self.scheduledTimerInterval = interval
            self.scheduledTimerBlock = block

            return TimerMock()
        }

        invocationQueueMock.asyncImp = { work in

            self.isOnInvocationQueue = true
            work()
            self.isOnInvocationQueue = false
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

        transitionCommand.invokeImp = { initialResults in

            self.transitionCommandInvocationData = initialResults
            self.transitionCommandInvokedOnQueue = self.isOnInvocationQueue
        }

        return transitionCommand
    }

    func invocationQueue() -> DispatchQueueMock {

        invocationQueueMock
    }

    func appTitle() -> String {

        StartupScreenTestConstants.appTitle
    }

    func modelIsCreated(transitionCommand: StartupTransitionCommandMock = StartupTransitionCommandMock(), searchService: CitySearchServiceMock = CitySearchServiceMock()) -> StartupModelImp {

        StartupModelImp(timerType: TimerMock.self, transitionCommand: transitionCommand, searchService: searchService, invocationQueue: invocationQueueMock)
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

        let serviceFuture = CitySearchService.SearchFuture({ promise in

            self.servicePromise = promise
        })

        searchService.citySearchImp = {

            self.searchServiceThatReceivedRequest = searchService

            return serviceFuture
        }

        return searchService
    }

    func initialResults(from: CitySearchServiceMock) -> CitySearchResults {

        initialResults
    }

    func searchServiceHasReturnedResults(_ service: CitySearchServiceMock) {

        servicePromise(.success(initialResults))
    }

    func appTitleTextIsUpdated(_ textUpdate: ValueUpdate<String>, toValue expectedText: String) {

        XCTAssertEqual(observedAppTitleText, expectedText, "App title text was not updated immediately")
    }

    func timerIsScheduled(withInterval expectedInterval: TimeInterval) {

        XCTAssertEqual(scheduledTimerInterval, expectedInterval)
    }

    func transitionCommand(_ transitionCommand: StartupTransitionCommandMock, isInvokedWith expectedResults: CitySearchResults, onQueue expectedQueue: DispatchQueueMock) {

        XCTAssertEqual(transitionCommandInvocationData, expectedResults, "Transition command was not invoked with correct results")
        XCTAssertTrue(transitionCommandInvokedOnQueue, "Transition command was not invoked with on the invocation queue")
    }

    func transitionCommandIsNotInvoked(_ transitionCommand: StartupTransitionCommandMock) {

        XCTAssertNil(transitionCommandInvocationData, "Transition command was invoked before results are ready")
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

class DispatchQueueMock: IDispatchQueue {

    var asyncImp: (_ work: @escaping @convention(block) () -> ()) -> Void = { work in }
    func async(_ work: @escaping @convention(block) () -> ()) {

        asyncImp(work)
    }
}