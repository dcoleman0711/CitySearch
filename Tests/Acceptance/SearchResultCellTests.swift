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

    func testTitleFitsText() {

        let cellSizes = given.cellSizes()

        for cellSize in cellSizes {

            testTitleFitsText(cellSize: cellSize)
        }
    }

    func testTitleFitsText(cellSize: CGSize) {

        let titleText = given.titleText()
        let titleLabel = given.titleLabel(titleText)
        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel)

        when.cellSizeBecomes(searchResultCell, cellSize)

        then.titleLabelFitsWidth(titleLabel, of: searchResultCell)
    }

    func testCellTitleLabelText() {

        let searchResult = given.searchResult()
        let titleText = given.titleText(for: searchResult)
        let titleLabel = given.titleLabel()
        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel)

        when.assignResult(searchResult, toCell: searchResultCell)

        then.titleLabel(titleLabel, textIs: titleText)
    }

    func testImageViewSquare() {

        let cellSizes = given.cellSizes()

        for cellSize in cellSizes {

            testImageViewSquare(cellSize: cellSize)
        }
    }

    func testImageViewSquare(cellSize: CGSize) {

        let imageView = given.imageView()
        let searchResultCell = given.searchResultCellIsCreated(imageView: imageView)

        when.cellSizeBecomes(searchResultCell, cellSize)

        then.imageViewIsSquare(imageView)
    }

    func testImageViewCenteredHorizontally() {

        let cellSizes = given.cellSizes()

        for cellSize in cellSizes {

            testImageViewCenteredHorizontally(cellSize: cellSize)
        }
    }

    func testImageViewCenteredHorizontally(cellSize: CGSize) {

        let titleLabel = given.titleLabel()
        let imageView = given.imageView()
        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel, imageView: imageView)

        when.cellSizeBecomes(searchResultCell, cellSize)

        then.imageView(imageView, isCenteredHorizontallyIn: searchResultCell)
    }
    
    func testImageViewFitsVertically() {

        let cellSizes = given.cellSizes()

        for cellSize in cellSizes {

            testImageViewFitsVertically(cellSize: cellSize)
        }
    }

    func testImageViewFitsVertically(cellSize: CGSize) {

        let titleLabel = given.titleLabel()
        let imageView = given.imageView()
        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel, imageView: imageView)

        when.cellSizeBecomes(searchResultCell, cellSize)

        then.imageView(imageView, isFittedFromTopOf: searchResultCell, toTopOf: titleLabel)
    }

    func testImageViewCornerRadius() {

        let imageView = given.imageView()
        let cornerRadius = given.cornerRadius()

        let searchResultCell = when.searchResultCellIsCreated(imageView: imageView)

        then.imageView(imageView, cornerRadiusIs: cornerRadius)
    }

    func testImageViewImageIsAspectFill() {

        let imageView = given.imageView()

        let searchResultCell = when.searchResultCellIsCreated(imageView: imageView)

        then.imageViewDisplayImageWithAspectFill(imageView)
    }
}

class SearchResultCellSteps {

    func searchResult() -> CitySearchResult {

        CitySearchResultsStub.stubResults().results[0]
    }

    func titleText(for searchResult: CitySearchResult) -> String {

        searchResult.name
    }

    func titleText() -> String {

        "Test Title"
    }

    func titleLabel(_ text: String = "") -> UILabel {

        let label = UILabel()
        label.text = text
        return label
    }

    func imageView() -> UIImageView {

        UIImageView()
    }

    func cornerRadius() -> CGFloat {

        52.0
    }

    func cellSizes() -> [CGSize] {

        [CGSize(width: 128, height: 128), CGSize(width: 64, height: 64), CGSize(width: 32, height: 32)]
    }

    func searchResultCellIsCreated(titleLabel: UILabel = UILabel(), imageView: UIImageView = UIImageView()) -> CitySearchResultCell {

        imageView.image = UIImage(named: "TestImage.jpg", in: Bundle(for: SearchResultCellSteps.self), with: nil)
        return CitySearchResultCell(titleLabel: titleLabel, imageView: imageView, binder: ViewBinderImp())
    }

    func assignResult(_ result: CitySearchResult, toCell cell: CitySearchResultCell) {

        let modelFactory = CitySearchResultModelFactoryImp()
        let viewModelFactory = CitySearchResultViewModelFactoryImp()

        let model = modelFactory.resultModel(searchResult: result, tapCommandFactory: OpenDetailsCommandFactoryMock())
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

    func titleLabelFitsWidth(_ titleLabel: UILabel, of cell: CitySearchResultCell) {

        XCTAssertEqual(titleLabel.frame.size.width, cell.frame.size.width, "Title label size does not fit cell width")
    }

    func imageViewIsSquare(_ imageView: UIImageView) {

        XCTAssertEqual(imageView.frame.size.width, imageView.frame.size.height, "Image view is not square")
    }

    func imageView(_ imageView: UIImageView, isCenteredHorizontallyIn cell: CitySearchResultCell) {

        XCTAssertEqual(imageView.frame.center.x, cell.bounds.center.x, "Image view top is not centered horizontally in cell")
    }

    func imageView(_ imageView: UIImageView, isFittedFromTopOf cell: CitySearchResultCell, toTopOf titleLabel: UILabel) {

        XCTAssertEqual(imageView.frame.minY, cell.bounds.minY, "Image view top is not cell top")
        XCTAssertEqual(imageView.frame.maxY, titleLabel.frame.minY, "Image view bottom is not title label top")
    }

    func imageView(_ imageView: UIImageView, cornerRadiusIs cornerRadius: CGFloat) {

        XCTAssertTrue(imageView.layer.masksToBounds, "Image view must be masked to bounds to have rounded corners")
        XCTAssertEqual(imageView.layer.cornerRadius, cornerRadius, "Image view corner radius is not correct")
    }

    func imageViewDisplayImageWithAspectFill(_ imageView: UIImageView) {

        XCTAssertEqual(imageView.contentMode, UIView.ContentMode.scaleAspectFill, "Image view does not display image with aspect fill")
    }
}