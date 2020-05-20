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

    func testParallaxViewAutoResizeMaskDisabled() {

        let parallaxView = given.parallaxView()
        let searchView = given.searchViewIsCreated(parallaxView: parallaxView)

        when.searchViewIsLoaded(searchView)

        then.autoResizeMaskIsDisabled(parallaxView.view)
    }

    func testParallaxViewFillsHorizontallyAndIsCenteredVerticallyInParentSafeArea() {

        let parallaxView = given.parallaxView()
        let searchView = given.searchViewIsCreated(parallaxView: parallaxView)
        let expectedConstraints = given.constraintsFor(parallaxView.view, toFillParent: searchView)

        when.searchViewIsLoaded(searchView)

        then.searchView(searchView, hasConstraints: expectedConstraints)
    }

    func testSearchResultsViewIsOnSearchView() {

        let searchResultsView = given.searchResultsView()
        let searchView = given.searchViewIsCreated(searchResultsView: searchResultsView)

        when.searchViewIsLoaded(searchView)

        then.searchResultsView(searchResultsView.view, isOnSearchView: searchView)
    }

    func testSearchResultsViewAutoResizeMaskDisabled() {

        let searchResultsView = given.searchResultsView()
        let searchView = given.searchViewIsCreated(searchResultsView: searchResultsView)

        when.searchViewIsLoaded(searchView)

        then.autoResizeMaskIsDisabled(searchResultsView.view)
    }

    func testSearchResultsViewFillsHorizontallyAndIsCenteredVerticallyInParentSafeArea() {

        let searchResultsView = given.searchResultsView()
        let searchView = given.searchViewIsCreated(searchResultsView: searchResultsView)
        let expectedConstraints = given.constraintsFor(searchResultsView.view, toFillHorizontallyAndCenterVerticallyInParentSafeArea: searchView)

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

    func parallaxView() -> ParallaxViewMock {

        ParallaxViewMock()
    }

    func constraintsFor(_ view: UIView, toFillHorizontallyAndCenterVerticallyInParentSafeArea searchView: SearchViewImp) -> [NSLayoutConstraint] {

        [view.leftAnchor.constraint(equalTo: searchView.view.safeAreaLayoutGuide.leftAnchor),
         view.rightAnchor.constraint(equalTo: searchView.view.safeAreaLayoutGuide.rightAnchor),
         view.centerYAnchor.constraint(equalTo: searchView.view.centerYAnchor),
         view.heightAnchor.constraint(equalToConstant: SearchScreenTestConstants.resultsHeight)]
    }

    func constraintsFor(_ view: UIView, toFillParent searchView: SearchViewImp) -> [NSLayoutConstraint] {

        [view.leftAnchor.constraint(equalTo: searchView.view.leftAnchor),
         view.rightAnchor.constraint(equalTo: searchView.view.rightAnchor),
         view.topAnchor.constraint(equalTo: searchView.view.topAnchor),
         view.bottomAnchor.constraint(equalTo: searchView.view.bottomAnchor)]
    }

    func searchViewIsCreated(searchResultsView: SearchResultsViewMock = SearchResultsViewMock(), parallaxView: ParallaxViewMock = ParallaxViewMock(), model: SearchModelMock = SearchModelMock()) -> SearchViewImp {

        SearchViewImp(parallaxView: parallaxView, searchResultsView: searchResultsView, model: model)
    }

    func searchViewIsLoaded(_ searchView: SearchViewImp) {

        searchView.loadViewIfNeeded()
    }

    func searchResultsView(_ appTitleLabel: UIView, isOnSearchView searchView: SearchViewImp) {

        XCTAssertTrue(searchView.view.subviews.contains(appTitleLabel), "Search view does not contain app title label")
    }

    func autoResizeMaskIsDisabled(_ view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresizing mask is not disabled")
    }

    func searchView(_ searchView: SearchViewImp, hasConstraints expectedConstraints: [NSLayoutConstraint]) {

        ViewConstraintValidator.validateThatView(searchView.view, hasConstraints: expectedConstraints, message: "Search view does not contain expected constraints")
    }
}

class ViewConstraintValidator {

    static func validateThatView(_ view: UIView, hasConstraints expectedConstraints: [NSLayoutConstraint], message: String) {

        XCTAssertTrue(expectedConstraints.allSatisfy { first in view.constraints.contains { second in first.isEqualToConstraint(second) } }, message)
    }
}