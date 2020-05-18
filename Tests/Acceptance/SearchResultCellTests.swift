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
    func testTitleBottomCenter() {

        let cellSizes = given.cellSizes()

        for cellSize in cellSizes {

            testTitleBottomCenter(cellSize: cellSize)
        }
    }

    func testTitleBottomCenter(cellSize: CGSize) {

        let titleLabel = given.titleLabel()
        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel)

        when.cellSizeBecomes(searchResultCell, cellSize)

        then.titleLabel(titleLabel, isBottomCenteredIn: searchResultCell)
    }

    func testCellTitleLabelText() {

        let searchResult = given.searchResult()
        let titleText = given.titleText(for: searchResult)
        let titleLabel = given.titleLabel()
        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel)

        when.assignResult(searchResult, toCell: searchResultCell)

        then.titleLabel(titleLabel, textIs: titleText)
    }
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

    func cellSizes() -> [CGSize] {

        [CGSize(width: 128, height: 128), CGSize(width: 64, height: 64), CGSize(width: 32, height: 32)]
    }

    func searchResultCellIsCreated(titleLabel: UILabel) -> CitySearchResultCell {

        CitySearchResultCell(titleLabel: titleLabel, binder: ViewBinderImp())
    }

    func assignResult(_ result: CitySearchResult, toCell cell: CitySearchResultCell) {

        let modelFactory = CitySearchResultModelFactoryImp()
        let viewModelFactory = CitySearchResultViewModelFactoryImp()

        let model = modelFactory.resultModel(searchResult: result)
        let viewModel = viewModelFactory.resultViewModel(model: model)

        cell.viewModel = viewModel
    }

    func cellSizeBecomes(_ cell: CitySearchResultCell, _ size: CGSize) {

        cell.frame = CGRect(origin: CGPoint.zero, size: size)

        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }

    func titleLabel(_ titleLabel: UILabel, textIs expectedText: String) {

        XCTAssertEqual(titleLabel.text, expectedText, "Title label text is not expected text")
    }

    func titleLabel(_ titleLabel: UILabel, isBottomCenteredIn cell: CitySearchResultCell) {
        
        XCTAssertEqual(titleLabel.frame.center.x, cell.bounds.center.x, "Title label is not horizontally centered in frame")
        XCTAssertEqual(titleLabel.frame.maxY, cell.bounds.maxY, "Title label is not in bottom of frame")
    }

}

extension CGRect {

    var center: CGPoint {

        CGPoint(x: origin.x + size.width / 2.0, y: origin.y + size.height / 2.0)
    }
}