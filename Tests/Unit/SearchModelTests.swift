//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class SearchModelTests: XCTestCase {

    var steps: SearchModelSteps!

    var given: SearchModelSteps { steps }
    var when: SearchModelSteps { steps }
    var then: SearchModelSteps { steps }

    override func setUp() {

        super.setUp()

        steps = SearchModelSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }
}

class SearchModelSteps {

    private var displayedSearchResults: CitySearchResults?

    func initialData() -> CitySearchResults {

        CitySearchResultsStub.stubResults()
    }

    func searchResultsModel() -> SearchResultsModelMock {

        let model = SearchResultsModelMock()

        model.setResultsImp = { (results) in

            self.displayedSearchResults = results
        }

        return model
    }

    func searchResultsModel(_ searchResultsModel: SearchResultsModelMock, isDisplayingData expectedData: CitySearchResults) {

        XCTAssertEqual(displayedSearchResults, expectedData, "Search results model is not displaying expected data")
    }
}
