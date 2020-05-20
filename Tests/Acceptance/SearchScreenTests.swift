//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class SearchScreenTestConstants {

    static let resultsHeight: CGFloat = 256.0
}

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

    func testParallaxFullScreen() {

        let parallaxView = given.parallaxView()
        let searchScreen = given.searchScreen(parallaxView: parallaxView)
        given.searchScreenIsLoaded(searchScreen)

        when.searchViewAppearsOnScreen(searchScreen)

        then.parallaxView(parallaxView, isFullScreenIn: searchScreen)
    }

    func testParallaxOffset() {

        let parallaxView = given.parallaxView()
        let searchResults = given.searchResults()
        let searchScreen = given.searchScreen(parallaxView: parallaxView, searchResults: searchResults)
        given.searchScreenIsLoaded(searchScreen)
        let contentOffset = given.contentOffset()

        when.searchResults(searchScreen, scrollsTo: contentOffset)

        then.parallaxView(parallaxView, contentOffsetIs: contentOffset)
    }

    func testOrientations() {

        let searchScreen = given.searchScreen()
        let landscapeOrientations = given.landscapeOrientations()

        when.searchScreenIsLoaded(searchScreen)

        then.searchScreen(searchScreen, supportedOrientationsAre: landscapeOrientations)
    }
    
    func testSearchResultsFullWidthAndCenteredVerticallyInSafeArea() {

        let searchResults = given.searchResults()
        let searchView = given.searchScreen(searchResults: searchResults)
        given.searchScreenIsLoaded(searchView)

        when.searchViewAppearsOnScreen(searchView)

        then.searchResultsFillsHorizontallyAndIsCenteredVerticallyInSafeArea(searchResults)
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
        given.searchScreenIsLoaded(searchView)
        let openDetailsCommand = given.openDetailsCommand(for: searchResult)

        when.invoke(openDetailsCommand)

        then.detailsScreenIsPushedOntoNavigationStack(detailsScreen)
    }
}

class SearchScreenSteps {

    private let navigationStack = UINavigationControllerMock()
    private let parallaxViewModel = ParallaxViewModelMock()
    private let searchResultsModel = SearchResultsModelMock()
    private let searchResultsViewModel = SearchResultsViewModelMock()
    private let cityDetailsViewFactory = CityDetailsViewFactoryMock()

    private var displayedSearchResults: CitySearchResults?

    private var safeAreaFrame = CGRect.zero

    private var openDetailsCommandFactory: OpenDetailsCommandFactory!

    private var pushedViewControllers: [UIViewController] = []

    private var openDetailsCommands: [String: OpenDetailsCommand] = [:]

    private var parallaxViewContentOffset = CGPoint.zero
    private var searchResultsContentOffsetObserver: ValueUpdate<CGPoint>?

    init() {

        parallaxViewModel.subscribeToContentOffsetImp = {

            { contentOffset in

                self.parallaxViewContentOffset = contentOffset
            }
        }

        searchResultsModel.setResultsImp = { (results) in

            self.displayedSearchResults = results
            self.openDetailsCommands = [String: OpenDetailsCommand](uniqueKeysWithValues: results.results.map { result -> (String, OpenDetailsCommand) in (result.name, self.openDetailsCommandFactory.openDetailsCommand(for: result)) })
        }

        // We're wrapping a production view model inside a mock one, because we want the real behavior (these are high-level integration tests), but we want to capture some of the messages being sent to the real view model.  The mock intercepts messages, stores them, then forwards them to the production view model
        let realViewModel = SearchResultsViewModelImp(model: searchResultsModel, viewModelFactory: CitySearchResultViewModelFactoryImp())

        searchResultsViewModel.observeResultsViewModelsImp = { observer in realViewModel.observeResultsViewModels(observer) }

        searchResultsViewModel.observeContentOffsetImp = { observer in

            self.searchResultsContentOffsetObserver = observer
            realViewModel.observeContentOffset(observer)
        }

        navigationStack.pushViewControllerImp = { viewController, animated in

            self.pushedViewControllers.append(viewController)
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

    func contentOffset() -> CGPoint {

        CGPoint(x: 10.0, y: 0.0)
    }

    func searchResults() -> SearchResultsView {

        SearchResultsViewImp(viewModel: searchResultsViewModel)
    }

    func parallaxView() -> ParallaxView {

        ParallaxViewImp(viewModel: parallaxViewModel)
    }

    func searchScreen(parallaxView: ParallaxView = ParallaxViewImp(), searchResults: SearchResultsView = SearchResultsViewImp(viewModel: SearchResultsViewModelMock()), initialData: CitySearchResults = CitySearchResults.emptyResults()) -> SearchView {

        let parallaxViewModelFactory = ParallaxViewModelFactoryMock()
        parallaxViewModelFactory.parallaxViewModelImp = { self.parallaxViewModel }

        let parallaxViewFactory = ParallaxViewFactoryMock()
        parallaxViewFactory.parallaxViewImp = { viewModel in parallaxView}

        let searchResultsModelFactory = SearchResultsModelFactoryMock()

        searchResultsModelFactory.searchResultsModelImp = { openDetailsCommandFactory in

            self.openDetailsCommandFactory = openDetailsCommandFactory
            return self.searchResultsModel
        }

        let searchResultsViewModelFactory = SearchResultsViewModelFactoryMock()
        searchResultsViewModelFactory.searchResultsViewModelImp = { model, resultViewModelFactory in self.searchResultsViewModel }

        let searchResultsViewFactory = SearchResultsViewFactoryMock()
        searchResultsViewFactory.searchResultsViewImp = { viewModel in searchResults }

        let builder = SearchViewBuilder()
        builder.initialData = initialData
        builder.parallaxViewModelFactory = parallaxViewModelFactory
        builder.parallaxViewFactory = parallaxViewFactory
        builder.searchResultsViewFactory = searchResultsViewFactory
        builder.searchResultsViewModelFactory = searchResultsViewModelFactory
        builder.searchResultsModelFactory = searchResultsModelFactory
        builder.cityDetailsViewFactory = cityDetailsViewFactory

        let searchScreen = builder.build()
        navigationStack.viewControllers = [searchScreen]
        return searchScreen
    }

    func searchScreenIsLoaded(_ searchView: SearchView) {

        searchView.loadViewIfNeeded()
    }

    func searchViewAppearsOnScreen(_ searchView: SearchView) {

        SafeAreaLayoutTest.layoutInWindow(searchView, andCaptureSafeAreaTo: &self.safeAreaFrame)
    }

    func searchResults(_ searchScreen: SearchView, scrollsTo contentOffset: CGPoint) {

        searchResultsContentOffsetObserver?(contentOffset)
    }

    func searchResult(in searchResults: CitySearchResults) -> CitySearchResult {

        searchResults.results[searchResults.results.count / 2]
    }

    func openDetailsCommand(for searchResult: CitySearchResult) -> OpenDetailsCommand {

        openDetailsCommands[searchResult.name]!
    }

    func detailsScreen(for searchResult: CitySearchResult) -> CityDetailsViewMock {

        let detailsScreen = CityDetailsViewMock()

        cityDetailsViewFactory.detailsViewImp = { result in

            if result == searchResult { return detailsScreen }

            return CityDetailsViewMock()
        }

        return detailsScreen
    }

    func invoke(_ openDetailsCommand: OpenDetailsCommand) {

        openDetailsCommand.invoke()
    }

    func parallaxView(_ parallaxView: ParallaxView, contentOffsetIs contentOffset: CGPoint) {

        XCTAssertEqual(self.parallaxViewContentOffset, contentOffset, "Parallax view content offset is not correct")
    }

    func searchResults(_ searchResults: SearchResultsView, isDisplayedIn searchView: SearchView) {

        XCTAssertTrue(searchResults.view.isDescendant(of: searchView.view), "Search results are not displayed in search view")
    }

    func searchResultsFillsHorizontallyAndIsCenteredVerticallyInSafeArea(_ searchResults: SearchResultsView) {

        let fillsHorizontally =
                searchResults.view.frame.minX == safeAreaFrame.minX &&
                searchResults.view.frame.maxX == safeAreaFrame.maxX

        let centeredVertically = searchResults.view.center.y == safeAreaFrame.center.y
        let correctHeight = searchResults.view.frame.size.height == SearchScreenTestConstants.resultsHeight

        XCTAssertTrue(fillsHorizontally, "Search results do not fill safe area horizontally")
        XCTAssertTrue(centeredVertically, "Search results are not centered vertically")
        XCTAssertTrue(correctHeight, "Search results does not have correct height")
    }

    func parallaxView(_ parallaxView: ParallaxView, isFullScreenIn searchScreen: SearchView) {

        XCTAssertEqual(parallaxView.view.frame, searchScreen.view.bounds, "Parallax view is not full screen in search screen")
    }

    func searchScreenBackgroundIsWhite(_ searchScreen: SearchView) {

        XCTAssertEqual(searchScreen.view.backgroundColor, UIColor.white, "Search screen background is not white")
    }

    func searchResultsAreDisplayed(_ expectedData: CitySearchResults) {

        XCTAssertEqual(displayedSearchResults, expectedData, "Search results is not displaying expected data")
    }

    func searchScreen(_ searchScreen: SearchView, supportedOrientationsAre expectedOrientations: UIInterfaceOrientationMask) {

        XCTAssertEqual(searchScreen.supportedInterfaceOrientations, expectedOrientations, "Supported orientations are not the expected orientations")
    }

    func detailsScreenIsPushedOntoNavigationStack(_ detailsScreen: CityDetailsViewMock) {

        XCTAssertEqual(pushedViewControllers, [detailsScreen], "Details screen was not pushed onto navigation stack")
    }
}

class SafeAreaLayoutTest {

    static func layoutInWindow(_ viewController: UIViewController, andCaptureSafeAreaTo safeArea: inout CGRect) {

        // Testing the safe area insets requires placing the view into a hierarchy all the way up to a window.
        let window = UIWindow()
        window.makeKeyAndVisible()
        window.rootViewController = viewController
        viewController.view.setNeedsLayout()
        viewController.view.layoutIfNeeded()

        var safeAreaFrame = viewController.view.bounds
        let safeAreaInsets = viewController.view.safeAreaInsets

        safeAreaFrame.origin.x += safeAreaInsets.left
        safeAreaFrame.size.width -= (safeAreaInsets.left + safeAreaInsets.right)
        safeAreaFrame.origin.y += safeAreaInsets.top
        safeAreaFrame.size.height -= (safeAreaInsets.top + safeAreaInsets.bottom)

        safeArea = safeAreaFrame

        // Reset the window to avoid breaking other tests
        window.isHidden = true
        window.windowScene = nil
    }
}