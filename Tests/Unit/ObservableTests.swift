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

    func testSubscribeAndUpdate() {

        let value = given.value()
        let observable = given.observable(value)
        let valueUpdate = given.valueUpdate()
        given.subscribe(observable, valueUpdate)
        let newValue = given.newValue()

        when.observable(observable, isSetTo: newValue)

        then.value(valueUpdate, wasUpdatedTo: newValue)
    }

    func testMultipleSubscriptions() {

        let value = given.value()
        let observable = given.observable(value)
        let valueUpdates = given.arrayOfValueUpdates()
        given.subscribe(observable, valueUpdates)
        let newValue = given.newValue()

        when.observable(observable, isSetTo: newValue)

        then.values(valueUpdates, wereUpdatedTo: newValue)
    }

    func testMap() {

        let value = given.value()
        let observable = given.observable(value)
        let intObservable = given.intObservable()
        let intValueUpdate = given.intValueUpdate()
        let mapFunction = given.mapFunction()
        given.observable(observable, isMappedTo: intObservable, mapFunction: mapFunction)
        given.subscribeInt(intObservable, intValueUpdate)
        let newValue = given.newValue()
        let mappedNewValue = given.mappedValue(newValue, mapFunction)

        when.observable(observable, isSetTo: newValue)

        then.intValue(intValueUpdate, wasUpdatedTo: mappedNewValue)
    }
}

class ObservableSteps {

    private var updatedValue = ""
    private var updatedValues: [String] = []

    private var updatedIntValue: Int?

    func observable(_ observable: Observable<String>, isSetTo newValue: String) {

        observable.value = newValue
    }

    func value() -> String {

        "testValue"
    }

    func newValue() -> String {

        value() + "New"
    }

    func observable(_ value: String) -> Observable<String> {

        Observable<String>(value)
    }

    func valueUpdate() -> ValueUpdate<String> {

        { (value) in

            self.updatedValue = value
        }
    }

    func arrayOfValueUpdates() -> [ValueUpdate<String>] {

        let indices = (0..<5)

        updatedValues = indices.map { _ in "" }

        return indices.map { index in

            { value in

                self.updatedValues[index] = value
            }
        }
    }

    func subscribeAndUpdateImmediately(_ observable: Observable<String>, _ valueUpdate: @escaping ValueUpdate<String>) {

        observable.subscribe(valueUpdate, updateImmediately: true)
    }

    func subscribe(_ observable: Observable<String>, _ update: @escaping ValueUpdate<String>) {

        observable.subscribe(update)
    }

    func subscribe(_ observable: Observable<String>, _ updates: [ValueUpdate<String>]) {

        for update in updates {

            observable.subscribe(update)
        }
    }

    func intObservable() -> Observable<Int> {

        Observable<Int>(0)
    }

    func subscribeInt(_ observable: Observable<Int>, _ update: @escaping ValueUpdate<Int>) {

        observable.subscribe(update)
    }

    func intValueUpdate() -> ValueUpdate<Int> {

        { int in

            self.updatedIntValue = int
        }
    }

    func mapFunction() -> (String) -> Int {

        { string in

            string.count
        }
    }

    func observable(_ observable: Observable<String>, isMappedTo observableInt: Observable<Int>, mapFunction: @escaping (String) -> Int) {

        observableInt.map(observable, mapFunction)
    }

    func mappedValue(_ value: String, _ mapFunction: (String) -> Int) -> Int {

        mapFunction(value)
    }

    func value(_ valueUpdate: ValueUpdate<String>, wasUpdatedTo expectedValue: String) {

        XCTAssertEqual(self.updatedValue, expectedValue, "Value was not updated")
    }

    func values(_ updates: [ValueUpdate<String>], wereUpdatedTo expectedValue: String) {

        XCTAssertTrue(self.updatedValues.allSatisfy { value in value == expectedValue }, "All listeners were not updated")
    }

    func intValue(_ update: ValueUpdate<Int>, wasUpdatedTo expectedValue: Int) {

        XCTAssertEqual(self.updatedIntValue, expectedValue, "Value was not updated")
    }
}