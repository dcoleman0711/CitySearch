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

    func testOrientations() {

        let searchScreen = given.searchScreen()
        let landscapeOrientations = given.landscapeOrientations()

        when.searchScreenIsLoaded(searchScreen)

        then.searchScreen(searchScreen, supportedOrientationsAre: landscapeOrientations)
    }
    
    func testSearchResultsFullScreenSafeArea() {

        let searchResults = given.searchResults()
        let searchView = given.searchScreen(searchResults: searchResults)
        given.searchScreenIsLoaded(searchView)

        when.searchViewAppearsOnScreen(searchView)

        then.searchResultsIsFullScreenInSafeArea(searchResults)
    }

    func testSearchResultsDisplaysInitialData() {

        let initialData = given.initialData()
        let searchResults = given.searchResults()
        let searchView = given.searchScreen(searchResults: searchResults, initialData: initialData)

        when.searchScreenIsLoaded(searchView)

        then.searchResultsAreDisplayed(initialData)
    }

    func testOpenDetailsCommand() {

        let initialData = given.initialData()
        let searchResults = given.searchResults()
        let searchResult = given.searchResult(in: initialData)
        let detailsScreen = given.detailsScreen(for: searchResult)
        let searchView = given.searchScreen(searchResults: searchResults, initialData: initialData)
        let openDetailsCommand = given.openDetailsCommand(for: searchResult)
        given.searchScreenIsLoaded(searchView)

        when.invoke(openDetailsCommand)

        then.detailsScreenIsPushedOntoNavigationStack(detailsScreen)
    }
}

class SearchScreenSteps {

    private let searchResultsModel = SearchResultsModelMock()

    private var displayedSearchResults: CitySearchResults?

    private var safeAreaFrame = CGRect.zero

    private var openDetailsCommandFactory: OpenDetailsCommandFactory?

    init() {

        searchResultsModel.setResultsImp = { (results) in

            self.displayedSearchResults = results
        }
    }

    func initialData() -> CitySearchResults {

        CitySearchResultsStub.stubResults()
    }

    func screenSizes() -> [CGSize] {

        [CGSize(width: 1024, height: 768), CGSize(width: 2048, height: 768), CGSize(width: 2048, height: 1536)]
    }

    func landscapeOrientations() -> UIInterfaceOrientationMask {

        UIInterfaceOrientationMask.landscape
    }

    func searchResults() -> SearchResultsView {

        let viewModel = SearchResultsViewModelImp(model: searchResultsModel, viewModelFactory: CitySearchResultViewModelFactoryImp())
        return SearchResultsViewImp(viewModel: viewModel)
    }

    func searchScreen(searchResults: SearchResultsView = SearchResultsViewImp(model: SearchResultsModelMock()), initialData: CitySearchResults = CitySearchResults.emptyResults()) -> SearchView {

        let searchResultsModelFactory = SearchResultsModelFactoryMock()

        searchResultsModelFactory.searchResultsModelImp = { openDetailsCommandFactory in

            self.openDetailsCommandFactory = openDetailsCommandFactory
            return self.searchResultsModel
        }

        let searchResultsViewFactory = SearchResultsViewFactoryMock()
        searchResultsViewFactory.searchResultsViewImp = { model in searchResults }

        let builder = SearchViewBuilder()
        builder.initialData = initialData
        builder.searchResultsViewFactory = searchResultsViewFactory
        builder.searchResultsModelFactory = searchResultsModelFactory

        return builder.build()
    }

    func searchScreenIsLoaded(_ searchView: SearchView) {

        searchView.loadViewIfNeeded()
    }

    func searchViewAppearsOnScreen(_ searchView: SearchView) {

        // Testing the safe area insets requires placing the view into a hierarchy all the way up to a window.
        let window = UIWindow()
        window.makeKeyAndVisible()
        window.rootViewController = searchView as? UIViewController
        searchView.view.setNeedsLayout()
        searchView.view.layoutIfNeeded()

        var safeAreaFrame = searchView.view.bounds
        let safeAreaInsets = searchView.view.safeAreaInsets

        safeAreaFrame.origin.x += safeAreaInsets.left
        safeAreaFrame.size.width -= (safeAreaInsets.left + safeAreaInsets.right)
        safeAreaFrame.origin.y += safeAreaInsets.top
        safeAreaFrame.size.height -= (safeAreaInsets.top + safeAreaInsets.bottom)

        self.safeAreaFrame = safeAreaFrame

        // Reset the window to avoid breaking other tests
        window.isHidden = true
        window.windowScene = nil
    }

    func searchResult(in searchResults: CitySearchResults) -> CitySearchResult {

        searchResults.results[searchResults.results.count / 2]
    }

    func openDetailsCommand(for searchResult: CitySearchResult) -> OpenDetailsCommand {

        self.openDetailsCommandFactory!.openDetailsCommand(for: searchResult)
    }

    func detailsScreen(for: CitySearchResult) -> CityDetailsViewMock {

        CityDetailsViewMock()
    }

    func invoke(_ openDetailsCommand: OpenDetailsCommand) {

        openDetailsCommand.invoke()
    }

    func searchResults(_ searchResults: SearchResultsView, isDisplayedIn searchView: SearchView) {

        XCTAssertTrue(searchResults.view.isDescendant(of: searchView.view), "Search results are not displayed in search view")
    }

    func searchResultsIsFullScreenInSafeArea(_ searchResults: SearchResultsView) {

        XCTAssertEqual(searchResults.view.frame, safeAreaFrame, "Search results are not full screen")
    }

    func searchScreenBackgroundIsWhite(_ searchScreen: SearchView) {

        XCTAssertEqual(searchScreen.view.frame, searchScreen.view.bounds, "Search results are not full screen")
    }

    func searchResultsAreDisplayed(_ expectedData: CitySearchResults) {

        XCTAssertEqual(displayedSearchResults, expectedData, "Search results is not displaying expected data")
    }

    func searchScreen(_ searchScreen: SearchView, supportedOrientationsAre expectedOrientations: UIInterfaceOrientationMask) {

        XCTAssertEqual(searchScreen.supportedInterfaceOrientations, expectedOrientations, "Supported orientations are not the expected orientations")
    }

    func detailsScreenIsPushedOntoNavigationStack(_ detailsScreen: CityDetailsViewMock) {


    }
}