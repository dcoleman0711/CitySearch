//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class SearchViewTests: XCTestCase {

    var steps: SearchViewSteps!

    var given: SearchViewSteps { steps }
    var when: SearchViewSteps { steps }
    var then: SearchViewSteps { steps }

    override func setUp() {

        super.setUp()

        steps = SearchViewSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testSearchResultsViewIsOnSearchView() {

        let searchResultsView = given.searchResultsView()
        let searchView = given.searchViewIsCreated(searchResultsView: searchResultsView)

        when.searchViewIsLoaded(searchView)

        then.searchResultsView(searchResultsView.view, isOnStartupView: searchView)
    }

    func testSearchResultsViewAutoResizeMaskDisabled() {

        let searchResultsView = given.searchResultsView()
        let searchView = given.searchViewIsCreated(searchResultsView: searchResultsView)

        when.searchViewIsLoaded(searchView)

        then.autoResizeMaskIsDisabled(searchResultsView.view)
    }

    func testSearchResultsViewFillsParent() {

        let searchResultsView = given.searchResultsView()
        let searchView = given.searchViewIsCreated(searchResultsView: searchResultsView)
        let expectedConstraints = given.constraintsFor(searchResultsView.view, toFillParent: searchView)

        when.searchViewIsLoaded(searchView)

        then.searchView(searchView, hasConstraints: expectedConstraints)
    }

    func testPassInitialDataToModelFactory() {

        let initialData = given.initialData()
        let modelFactory = given.modelFactory()

        let searchView = when.searchViewIsCreated(modelFactory: modelFactory, initialData: initialData)

        then.initialData(initialData, isPassedTo: modelFactory)
    }

    func testPassSearchResultsModelToModelFactory() {

        let searchResultsModel = given.searchResultsModel()
        let searchResultsView = given.searchResultsView(searchResultsModel)
        let modelFactory = given.modelFactory()

        let searchView = when.searchViewIsCreated(searchResultsView: searchResultsView, modelFactory: modelFactory)

        then.searchResultsModel(searchResultsModel, isPassedTo: modelFactory)
    }
}

class SearchViewSteps {

    private var initialDataPassedToModelFactory: CitySearchResults?
    private var searchResultsModelPassedToFactory: SearchResultsModel?

    func searchResultsModel() -> SearchResultsModelMock {

        SearchResultsModelMock()
    }

    func initialData() -> CitySearchResults {

        CitySearchResults()
    }

    func modelFactory() -> SearchModelFactoryMock {

        let model = SearchModelFactoryMock()

        model.searchModelImp = { (searchResultsModel, initialData) in

            self.searchResultsModelPassedToFactory = searchResultsModel
            self.initialDataPassedToModelFactory = initialData

            return SearchModelMock()
        }

        return model
    }

    func searchResultsView(_ searchResultsModel: SearchResultsModelMock = SearchResultsModelMock()) -> SearchResultsViewMock {

        let searchResultsView = SearchResultsViewMock()

        searchResultsView.model = searchResultsModel

        return searchResultsView
    }

    func constraintsFor(_ view: UIView, toFillParent searchView: SearchViewImp) -> [NSLayoutConstraint] {

        [view.leftAnchor.constraint(equalTo: searchView.view.leftAnchor),
         view.rightAnchor.constraint(equalTo: searchView.view.rightAnchor),
         view.topAnchor.constraint(equalTo: searchView.view.topAnchor),
         view.bottomAnchor.constraint(equalTo: searchView.view.bottomAnchor)]
    }

    func searchViewIsCreated(searchResultsView: SearchResultsViewMock = SearchResultsViewMock(), modelFactory: SearchModelFactoryMock = SearchModelFactoryMock(), initialData: CitySearchResults = CitySearchResults()) -> SearchViewImp {

        SearchViewImp(searchResultsView: searchResultsView, modelFactory: modelFactory, initialData: initialData)
    }

    func searchViewIsLoaded(_ searchView: SearchViewImp) {

        searchView.loadViewIfNeeded()
    }

    func searchResultsView(_ appTitleLabel: UIView, isOnStartupView startupView: SearchViewImp) {

        XCTAssertTrue(startupView.view.subviews.contains(appTitleLabel), "Startup view does not contain app title label")
    }

    func autoResizeMaskIsDisabled(_ view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresizing mask is not disabled")
    }

    func searchView(_ searchView: SearchViewImp, hasConstraints expectedConstraints: [NSLayoutConstraint]) {

        XCTAssertTrue(searchView.view.constraints.contains { constraint in expectedConstraints.contains { expectedConstraint in constraint.isEqualToConstraint(expectedConstraint) } }, "Startup view does not contain expected constraints")
    }

    func initialData(_ initialData: CitySearchResults, isPassedTo modelFactory: SearchModelFactoryMock) {

        XCTAssertTrue(initialDataPassedToModelFactory === initialData, "Initial data was not passed to model factory")
    }

    func searchResultsModel(_ searchResultsModel: SearchResultsModelMock, isPassedTo modelFactory: SearchModelFactoryMock) {

        XCTAssertTrue(searchResultsModelPassedToFactory === searchResultsModel, "SearchResultsModel was not passed to model factory")
    }
}
