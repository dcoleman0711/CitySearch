//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class SearchScreenTests: XCTestCase {

    var steps: SearchScreenSteps!

    var given: SearchScreenSteps { steps }
    var when: SearchScreenSteps { steps }
    var then: SearchScreenSteps { steps }

    override func setUp() {

        super.setUp()

        steps = SearchScreenSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testSearchResultsDisplayed() {

        let searchResults = given.searchResults()
        let searchView = given.searchView(searchResults)

        when.searchViewIsLoaded(searchView)

        then.searchResults(searchResults, isDisplayedIn: searchView)
    }
}

class SearchScreenSteps {

    func searchResults() -> SearchResultsViewMock {

        let searchResultsView = SearchResultsViewMock()

        let stubView = UIView()
        searchResultsView.viewGetter = { stubView }

        return searchResultsView
    }

    func searchView(_ searchResults: SearchResultsViewMock) -> SearchViewImp {

        SearchViewImp(searchResultsView: searchResults)
    }

    func searchViewIsLoaded(_ searchView: SearchViewImp) {

        searchView.loadViewIfNeeded()
    }

    func searchResults(_ searchResults: SearchResultsViewMock, isDisplayedIn searchView: SearchViewImp) {

        XCTAssertTrue(searchResults.view.isDescendant(of: searchView.view), "Search results are not displayed in search view")
    }
}