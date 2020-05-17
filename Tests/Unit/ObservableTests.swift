//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class ObservableTests: XCTestCase {

    var steps: ObservableSteps!

    var given: ObservableSteps { steps }
    var when: ObservableSteps { steps }
    var then: ObservableSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ObservableSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testSubscribeAndUpdateImmediately() {

        let value = given.value()
        let observable = given.observable(value)
        let valueUpdate = given.valueUpdate()

        when.subscribeAndUpdateImmediately(observable, valueUpdate)

        then.value(valueUpdate, wasUpdatedTo: value)
    }
}

class ObservableSteps {

    private var updatedValue = ""

    func value() -> String {

        "testValue"
    }

    func observable(_ value: String) -> Observable<String> {

        Observable<String>(value)
    }

    func valueUpdate() -> ValueUpdate<String> {

        { (value) in

            self.updatedValue = value
        }
    }

    func subscribeAndUpdateImmediately(_ observable: Observable<String>, _ valueUpdate: @escaping ValueUpdate<String>) {

        observable.subscribe(valueUpdate, updateImmediately: true)
    }

    func value(_ valueUpdate: ValueUpdate<String>, wasUpdatedTo expectedValue: String) {

        XCTAssertEqual(self.updatedValue, expectedValue, "Value was not updated")
    }
}