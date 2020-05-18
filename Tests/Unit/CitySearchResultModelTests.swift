//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class CitySearchResultViewModelTests: XCTestCase {

    var steps: CitySearchResultViewModelSteps!

    var given: CitySearchResultViewModelSteps { steps }
    var when: CitySearchResultViewModelSteps { steps }
    var then: CitySearchResultViewModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = CitySearchResultViewModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTitle() {

        let searchResult = given.searchResult()

        let model = when.modelIsCreated(searchResult: searchResult)

        then.model(model, titleIs: searchResult.name)
    }
}

class CitySearchResultViewModelSteps {

    func searchResult() -> CitySearchResult {

        CitySearchResult(name: "Test City")
    }

    func modelIsCreated(searchResult: CitySearchResult) -> CitySearchResultModelImp {

        CitySearchResultModelFactoryImp().resultModel(searchResult: searchResult) as! CitySearchResultModelImp
    }

    func model(_ model: CitySearchResultModelImp, titleIs expectedTitle: String) {

        XCTAssertEqual(model.titleText, expectedTitle, "Model title is not search result name")
    }
}