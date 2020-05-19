//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class DetailsModelTests: XCTestCase {

    var steps: DetailsModelSteps!

    var given: DetailsModelSteps { steps }
    var when: DetailsModelSteps { steps }
    var then: DetailsModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = DetailsModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTitleText() {

        let searchResult = given.searchResult()
        let titleText = given.titleText(for: searchResult)
        let detailsModel = given.detailsModelIsCreated(for: searchResult)
        let textObserver = given.textObserver()

        when.observer(textObserver, observesTitleOn: detailsModel)

        then.observedText(on: textObserver, isEqualTo: titleText)
    }
}

class DetailsModelSteps {

    private let titleTextObservable = ObservableMock<String>("")

    private var observedText: String?

    init() {

        var textValue = ""

        titleTextObservable.valueSetter = { text in textValue = text }

        titleTextObservable.subscribeImp = { observer, updateImmediately in

            if updateImmediately {

                observer(textValue)
            }
        }
    }

    func searchResult() -> CitySearchResult {

        CitySearchResult(name: "Test Title")
    }

    func titleText(for searchResult: CitySearchResult) -> String {

        searchResult.name
    }

    func detailsModelIsCreated(for searchResult: CitySearchResult) -> CityDetailsModelImp {

        CityDetailsModelImp(searchResult: searchResult, titleText: titleTextObservable)
    }

    func textObserver() -> ValueUpdate<String> {

        { text in

            self.observedText = text
        }
    }

    func observer(_ observer: @escaping ValueUpdate<String>, observesTitleOn model: CityDetailsModelImp) {

        model.observeTitleText(observer)
    }

    func observedText(on observer: ValueUpdate<String>, isEqualTo expectedText: String) {

        XCTAssertEqual(observedText, expectedText, "Observed text is not correct")
    }
}