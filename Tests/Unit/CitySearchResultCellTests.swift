//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class CitySearchResultCellTests: XCTestCase {

    var steps: CitySearchResultCellSteps!

    var given: CitySearchResultCellSteps { steps }
    var when: CitySearchResultCellSteps { steps }
    var then: CitySearchResultCellSteps { steps }

    override func setUp() {

        super.setUp()

        steps = CitySearchResultCellSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testTitleLabel() {

        let titleText = given.titleText()
        let viewModel = given.viewModel(titleText)
        let titleLabel = given.titleLabel()
        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel)

        when.assignViewModel(viewModel, toCell: searchResultCell)

        then.titleLabel(titleLabel, textIs: titleText)
    }
}

class CitySearchResultCellSteps {


    func titleText() -> String {

        "Test Title"
    }

    func titleLabel() -> UILabel {

        UILabel()
    }

    func viewModel(_ titleText: String) -> CitySearchResultViewModelMock {

        let viewModel = CitySearchResultViewModelMock()

        viewModel.titleText = titleText

        return viewModel
    }

    func searchResultCellIsCreated(titleLabel: UILabel) -> CitySearchResultCell {

        CitySearchResultCell(titleLabel: titleLabel)
    }

    func assignViewModel(_ viewModel: CitySearchResultViewModelMock, toCell cell: CitySearchResultCell) {

        cell.viewModel = viewModel
    }

    func titleLabel(_ label: UILabel, textIs expectedText: String) {

        XCTAssertEqual(label.text, expectedText, "Title label text is not correct")
    }
}