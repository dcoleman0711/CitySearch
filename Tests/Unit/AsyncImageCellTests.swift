//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest

import UIKit

class AsyncImageCellTests: XCTestCase {

    var steps: AsyncImageCellSteps!

    var given: AsyncImageCellSteps { steps }
    var when: AsyncImageCellSteps { steps }
    var then: AsyncImageCellSteps { steps }

    override func setUp() {

        super.setUp()

        steps = AsyncImageCellSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testImageViewImage() {

        let viewModel = given.viewModel()
        let imageView = given.imageView()
        let binder = given.binder()
        let imageCell = given.imageCellIsCreated(imageView: imageView, binder: binder)

        when.assignViewModel(viewModel, toCell: imageCell)

        then.imageView(imageView, isBoundTo: imageCell)
    }

    func testImageViewAutoResizeMaskDisabled() {

        let imageView = given.imageView()
        let imageCell = when.imageCellIsCreated(imageView: imageView)

        then.autoResizeMaskIsDisabled(for: imageView)
    }

    func testImageViewConstraints() {

        let imageView = given.imageView()
        let imageCell = when.imageCellIsCreated(imageView: imageView)

        then.imageView(imageView, fillsParent: imageCell)
    }
}

class AsyncImageCellSteps {

    var boundImageView: UIImageView?

    func binder() -> ViewBinderMock {

        let binder = ViewBinderMock()

        binder.bindImageImp = { (imageView) in

            { (image) in

                self.boundImageView = imageView
            }
        }

        return binder
    }

    func image() -> UIImageMock {

        UIImageMock()
    }

    func imageView() -> UIImageView {

        UIImageView()
    }

    func viewModel() -> AsyncImageViewModelMock {

        let viewModel = AsyncImageViewModelMock()

        viewModel.observeImageImp = { observer in

            observer(UIImageMock())
        }

        return viewModel
    }

    func imageCellIsCreated(imageView: UIImageView = UIImageView(), binder: ViewBinderMock = ViewBinderMock()) -> AsyncImageCell {

        AsyncImageCell(imageView: imageView, binder: binder)
    }

    func assignViewModel(_ viewModel: AsyncImageViewModelMock, toCell cell: AsyncImageCell) {

        cell.viewModel = viewModel
    }

    func imageView(_ imageView: UIImageView, isBoundTo expectedImage: AsyncImageCell) {

        XCTAssertEqual(boundImageView, imageView, "Image View image is bound to view model")
    }

    func autoResizeMaskIsDisabled(for view: UIView) {

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints, "Autoresize mask is not disabled")
    }

    func imageView(_ imageView: UIImageView, fillsParent cell: AsyncImageCell) {

        let expectedConstraints = [imageView.leftAnchor.constraint(equalTo: cell.leftAnchor),
                                   imageView.topAnchor.constraint(equalTo: cell.topAnchor),
                                   imageView.rightAnchor.constraint(equalTo: cell.rightAnchor),
                                   imageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)]

        validateConstraints(expectedConstraints: expectedConstraints, cell: cell, message: "Image view is not constrained to fill cell")
    }

    private func validateConstraints(expectedConstraints: [NSLayoutConstraint], cell: AsyncImageCell, message: String) {

        XCTAssertTrue(expectedConstraints.allSatisfy( { (first) in cell.constraints.contains(where: { (second) in first.isEqualToConstraint(second)}) }), message)
    }
}
