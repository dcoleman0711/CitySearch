//
//  SearchResultCellTests.swift
//  CitySearchTests
//
//  Created by Daniel Coleman on 5/17/20.
//  Copyright © 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class SearchResultCellTests: XCTestCase {

    var steps: SearchResultCellSteps!

    var given: SearchResultCellSteps { steps }
    var when: SearchResultCellSteps { steps }
    var then: SearchResultCellSteps { steps }

    override func setUp() {

        super.setUp()

        steps = SearchResultCellSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    // In Progress
//    func testCellTitleLabel() {
//
//        let searchResult = given.searchResult()
//        let titleText = given.titleText(for: searchResult)
//        let titleLabel = given.titleLabel()
//        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel)
//
//        when.assignResult(searchResult, toCell: searchResultCell)
//
//        then.titleLabel(titleLabel, textIs: titleText)
//    }
}

class SearchResultCellSteps {

    func searchResult() -> CitySearchResult {

        CitySearchResult(name: "Test City")
    }

    func titleText(for searchResult: CitySearchResult) -> String {

        searchResult.name
    }

    func titleLabel() -> UILabel {

        UILabel()
    }

    func searchResultCellIsCreated(titleLabel: UILabel) -> CitySearchResultCell {

        CitySearchResultCell(titleLabel: titleLabel)
    }

    func assignResult(_ result: CitySearchResult, toCell cell: CitySearchResultCell) {

        let modelFactory = CitySearchResultModelFactoryImp()
        let viewModelFactory = CitySearchResultViewModelFactoryImp()

        let model = modelFactory.resultModel(searchResult: result)
        let viewModel = viewModelFactory.resultViewModel(model: model)

        cell.viewModel = viewModel
    }

    func titleLabel(_ titleLabel: UILabel, textIs expectedText: String) {

        XCTAssertEqual(titleLabel.text, expectedText, "Title label text is not expected text")
    }
}