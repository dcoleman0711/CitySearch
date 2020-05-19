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

    func testSearchResultsViewFillsParentSafeArea() {

        let searchResultsView = given.searchResultsView()
        let searchView = given.searchViewIsCreated(searchResultsView: searchResultsView)
        let expectedConstraints = given.constraintsFor(searchResultsView.view, toFillParentSafeArea: searchView)

        when.searchViewIsLoaded(searchView)

        then.searchView(searchView, hasConstraints: expectedConstraints)
    }
}

class SearchViewSteps {

    private var initialDataPassedToModelFactory: CitySearchResults?
    private var searchResultsModelPassedToFactory: SearchResultsModel?

    func searchResultsModel() -> SearchResultsModelMock {

        SearchResultsModelMock()
    }

    func searchResultsView(_ searchResultsModel: SearchResultsModelMock = SearchResultsModelMock()) -> SearchResultsViewMock {

        let searchResultsView = SearchResultsViewMock()

        searchResultsView.model = searchResultsModel

        return searchResultsView
    }

    func constraintsFor(_ view: UIView, toFillParentSafeArea searchView: SearchViewImp) -> [NSLayoutConstraint] {

        [view.leftAnchor.constraint(equalTo: searchView.view.safeAreaLayoutGuide.leftAnchor),
         view.rightAnchor.constraint(equalTo: searchView.view.safeAreaLayoutGuide.rightAnchor),
         view.topAnchor.constraint(equalTo: searchView.view.safeAreaLayoutGuide.topAnchor),
         view.bottomAnchor.constraint(equalTo: searchView.view.safeAreaLayoutGuide.bottomAnchor)]
    }

    func searchViewIsCreated(searchResultsView: SearchResultsViewMock = SearchResultsViewMock(), model: SearchModelMock = SearchModelMock()) -> SearchViewImp {

        SearchViewImp(searchResultsView: searchResultsView, model: model)
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
}
