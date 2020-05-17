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

    func testSetInitialData() {

        let initialData = given.initialData()
        let searchResultsModel = given.searchResultsModel()

        let searchModel = when.createSearchModel(searchResultsModel: searchResultsModel, initialData: initialData)

        then.searchResultsModel(searchResultsModel, isDisplayingData: initialData)
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

    func createSearchModel(searchResultsModel: SearchResultsModelMock, initialData: CitySearchResults) -> SearchModelImp {

        SearchModelFactoryImp().searchModel(searchResultsModel: searchResultsModel, initialData: initialData) as! SearchModelImp
    }

    func searchResultsModel(_ searchResultsModel: SearchResultsModelMock, isDisplayingData expectedData: CitySearchResults) {

        XCTAssertEqual(displayedSearchResults, expectedData, "Search results model is not displaying expected data")
    }
}
