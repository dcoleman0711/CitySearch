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
        let searchView = given.searchScreen(searchResults: searchResults)

        when.searchScreenIsLoaded(searchView)

        then.searchResults(searchResults, isDisplayedIn: searchView)
    }

    func testBackgroundIsWhite() {

        let searchScreen = given.searchScreen()

        when.searchScreenIsLoaded(searchScreen)

        then.searchScreenBackgroundIsWhite(searchScreen)
    }
    
    func testSearchResultsFullScreen() {

        let screenSizes = given.screenSizes()

        for screenSize in screenSizes {

            testSearchResultsFullScreen(screenSize: screenSize)
        }
    }

    func testSearchResultsFullScreen(screenSize: CGSize) {

        let searchResults = given.searchResults()
        let searchView = given.searchScreen(searchResults: searchResults)
        given.searchScreenIsLoaded(searchView)

        when.searchView(searchView, sizeBecomes: screenSize)

        then.searchResults(searchResults, isFullScreenIn: searchView)
    }

    func testSearchResultsDisplaysInitialData() {

        let initialData = given.initialData()
        let searchResults = given.searchResults()
        let searchView = given.searchScreen(searchResults: searchResults, initialData: initialData)

        when.searchScreenIsLoaded(searchView)

        then.searchResults(searchResults, isDisplayingData: initialData)
    }
}

class SearchScreenSteps {

    private let searchResultsModel = SearchResultsModelMock()

    private var displayedSearchResults: CitySearchResults?

    init() {

        searchResultsModel.setResultsImp = { (results) in

            self.displayedSearchResults = results
        }
    }

    func initialData() -> CitySearchResults {

        CitySearchResults()
    }

    func screenSizes() -> [CGSize] {

        [CGSize(width: 1024, height: 768), CGSize(width: 2048, height: 768), CGSize(width: 2048, height: 1536)]
    }

    func searchResults() -> SearchResultsView {

        SearchResultsViewImp(model: searchResultsModel)
    }

    func searchScreen(searchResults: SearchResultsView = SearchResultsViewImp(), initialData: CitySearchResults = CitySearchResults()) -> SearchViewImp {

        SearchViewImp(searchResultsView: searchResults, modelFactory: SearchModelFactoryImp(), initialData: initialData)
    }

    func searchScreenIsLoaded(_ searchView: SearchView) {

        searchView.loadViewIfNeeded()
    }

    func searchView(_ searchView: SearchView, sizeBecomes size: CGSize) {

        searchView.view.frame = CGRect(origin: CGPoint.zero, size: size)
        searchView.view.setNeedsLayout()
        searchView.view.layoutIfNeeded()
    }

    func searchResults(_ searchResults: SearchResultsView, isDisplayedIn searchView: SearchViewImp) {

        XCTAssertTrue(searchResults.view.isDescendant(of: searchView.view), "Search results are not displayed in search view")
    }

    func searchResults(_ searchResults: SearchResultsView, isFullScreenIn searchView: SearchViewImp) {

        XCTAssertEqual(searchResults.view.frame, searchView.view.bounds, "Search results are not full screen")
    }

    func searchScreenBackgroundIsWhite(_ searchScreen: SearchView) {

        XCTAssertEqual(searchScreen.view.frame, searchScreen.view.bounds, "Search results are not full screen")
    }

    func searchResults(_ searchResults: SearchResultsView, isDisplayingData expectedData: CitySearchResults) {

        XCTAssertTrue(displayedSearchResults === expectedData, "Search results is not displaying expected data")
    }
}