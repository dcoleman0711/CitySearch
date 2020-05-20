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

    func testTitleLabelCornerRadius() {

        let titleLabel = given.titleLabel()
        let searchResultCell = when.searchResultCellIsCreated(titleLabel: titleLabel)
        let cornerRadius = given.cornerRadius()

        then.titleLabel(titleLabel, hasCornerRadius: cornerRadius)
    }

    func testTitleLabelBorderWidth() {

        let titleLabel = given.titleLabel()
        let searchResultCell = when.searchResultCellIsCreated(titleLabel: titleLabel)
        let borderWidth = given.borderWidth()

        then.titleLabel(titleLabel, hasBorderWidth: borderWidth)
    }

    func testTitleLabelWhiteBackground() {

        let titleLabel = given.titleLabel()
        let searchResultCell = when.searchResultCellIsCreated(titleLabel: titleLabel)

        then.titleLabelHasTranslucentWhiteBackground(titleLabel)
    }

    func testTitleLabelData() {

        let titleData = given.titleData()
        let viewModel = given.viewModel(titleData)
        let titleLabel = given.titleLabel()
        let binder = given.binder()
        let searchResultCell = given.searchResultCellIsCreated(titleLabel: titleLabel, binder: binder)

        when.assignViewModel(viewModel, toCell: searchResultCell)

        then.titleLabel(titleLabel, dataIs: titleData)
    }

    func testTitleLabelAutoResizeMaskDisabled() {

        let titleLabel = given.titleLabel()
        let searchResultCell = when.searchResultCellIsCreated(titleLabel: titleLabel)

        then.autoResizeMaskIsDisabled(for: titleLabel)
    }

    func testTitleLabelConstraints() {

        let titleLabel = given.titleLabel()
        let searchResultCell = when.searchResultCellIsCreated(titleLabel: titleLabel)

        then.titleLabel(titleLabel, isConstrainedToBottomCenterOf: searchResultCell)
    }

    func testImageViewData() {

        let viewModel = given.viewModel()
        let imageView = given.imageView()
        let binder = given.binder()
        let searchResultCell = given.searchResultCellIsCreated(imageView: imageView, binder: binder)

        when.assignViewModel(viewModel, toCell: searchResultCell)

        then.imageView(imageView, isBoundTo: viewModel)
    }
    
    func testImageViewAutoResizeMaskDisabled() {

        let imageView = given.imageView()
        let searchResultCell = when.searchResultCellIsCreated(imageView: imageView)

        then.autoResizeMaskIsDisabled(for: imageView)
    }

    func testImageViewSizeConstraints() {

        let imageView = given.imageView()
        let searchResultCell = when.searchResultCellIsCreated(imageView: imageView)

        then.imageView(imageView, isConstrainedToSquareIn: searchResultCell)
    }

    func testImageViewPositionConstraints() {

        let imageView = given.imageView()
        let titleLabel = given.titleLabel()
        let searchResultCell = when.searchResultCellIsCreated(titleLabel: titleLabel, imageView: imageView)

        then.imageView(imageView, isCenteredAndFittedIn: searchResultCell, above: titleLabel)
    }
}

class CitySearchResultCellSteps {

    private var labelBindings: [UILabel: LabelViewModel] = [:]
    private var boundImageView: UIImageView?

    private var iconImageObserver: ValueUpdate<UIImage>?

    private var imageViewBoundToIcon: UIImageView?

    func binder() -> ViewBinderMock {

        let binder = ViewBinderMock()

        binder.bindLabelTextImp = { (label) in

            { (viewModel) in

                self.labelBindings[label] = viewModel
            }
        }

        binder.bindImageImp = { imageView in

            { (image) in

                self.boundImageView = imageView
            }
        }

        return binder
    }

    func titleData() -> LabelViewModel {

        LabelViewModel(text: "Test Title", font: .systemFont(ofSize: 12.0))
    }

    func cornerRadius() -> CGFloat {

        8.0
    }

    func borderWidth() -> CGFloat {

        1.0
    }

    func titleLabel() -> UILabel {

        UILabel()
    }

    func imageView() -> UIImageView {

        UIImageView()
    }

    func viewModel(_ titleData: LabelViewModel = LabelViewModel.emptyData) -> CitySearchResultViewModelMock {

        let viewModel = CitySearchResultViewModelMock()

        viewModel.titleData = titleData

        viewModel.observeIconImageImp = { observer in

            observer(UIImageMock())
            self.imageViewBoundToIcon = self.boundImageView
        }

        return viewModel
    }

    func searchResultCellIsCreated(titleLabel: UILabel = UILabel(), imageView: UIImageView = UIImageView(), binder: ViewBinderMock = ViewBinderMock()) -> CitySearchResultCell {

        CitySearchResultCell(titleLabel: titleLabel, imageView: imageView, binder: binder)
    }

    func assignViewModel(_ viewModel: CitySearchResultViewModelMock, toCell cell: CitySearchResultCell) {

        cell.viewModel = viewModel
    }

    func titleLabel(_ label: UILabel, dataIs expectedData: LabelViewModel) {

        XCTAssertEqual(labelBindings[label], expectedData, "Title label text is not correct")
    }

    func titleLabelHasTranslucentWhiteBackground(_ titleLabel: UILabel) {

        XCTAssertEqual(titleLabel.backgroundColor, UIColor.white.withAlphaComponent(0.8), "Title label does not have white background")
    }

    func titleLabel(_ titleLabel: UILabel, hasCornerRadius expectedCornerRadius: CGFloat) {

        XCTAssertEqual(titleLabel.layer.cornerRadius, expectedCornerRadius, "Title label does not have the correct corner radius")
    }

    func titleLabel(_ titleLabel: UILabel, hasBorderWidth expectedBorderWidth: CGFloat) {

        XCTAssertEqual(titleLabel.layer.borderWidth, expectedBorderWidth, "Title label does not have the correct border width")
    }

    func titleLabel(_ titleLabel: UILabel, isConstrainedToBottomCenterOf cell: CitySearchResultCell) {

        let expectedConstraints = [titleLabel.leftAnchor.constraint(equalTo: cell.leftAnchor),
                                   titleLabel.rightAnchor.constraint(equalTo: cell.rightAnchor),
                                   titleLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                                   titleLabel.heightAnchor.constraint(equalToConstant: 24.0),]

        ViewConstraintValidator.validateThatView(cell, hasConstraints: expectedConstraints, message: "Title label is not constrained to bottom center of cell")
    }

    func autoResizeMaskIsDisabled(for view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresize mask is not disabled")
    }

    func imageView(_ imageView: UIImageView, isConstrainedToSquareIn cell: CitySearchResultCell) {

        let expectedConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0)

        ViewConstraintValidator.validateThatView(cell, hasConstraints: [expectedConstraint], message: "Image view is not constrained to be square")
    }

    func imageView(_ imageView: UIImageView, isCenteredAndFittedIn cell: CitySearchResultCell, above titleLabel: UILabel) {

        let expectedConstraints = [imageView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                                   imageView.topAnchor.constraint(equalTo: cell.topAnchor),
                                   imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor)]

        ViewConstraintValidator.validateThatView(cell, hasConstraints: expectedConstraints, message: "Image view is not constrained to horizontal center and above title label")
    }

    func imageView(_ imageView: UIImageView, isBoundTo viewModel: CitySearchResultViewModelMock) {

        XCTAssertEqual(imageViewBoundToIcon, imageView, "Icon Image View was not bound to view model")
    }
}