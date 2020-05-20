//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class ImageCarouselViewTests: XCTestCase {

    var steps: ImageCarouselViewSteps!

    var given: ImageCarouselViewSteps { steps }
    var when: ImageCarouselViewSteps { steps }
    var then: ImageCarouselViewSteps { steps }

    override func setUp() {

        super.setUp()

        steps = ImageCarouselViewSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testLayoutIsHorizontalFlow() {

        let collectionView = given.collectionView()

        let view = when.imageCarouselViewIsCreated(collectionView: collectionView)

        then.collectionViewLayoutIsHorizontalFlow(collectionView)
    }

    func testBackgroundColorIsClear() {

        let collectionView = given.collectionView()

        let view = when.imageCarouselViewIsCreated(collectionView: collectionView)

        then.collectionViewBackgroundColorIsClear(collectionView)
    }

    func testBindCollectionViewCells() {

        let collectionView = given.collectionView()
        let viewModel = given.imageCarouselViewModel()
        let binder = given.viewBinder()

        let view = when.imageCarouselViewIsCreated(collectionView: collectionView, viewModel: viewModel, binder: binder)

        then.collectionView(collectionView, cellsAreBoundTo: viewModel)
    }
}

class ImageCarouselViewSteps {

    private var boundCollectionView: UICollectionView?

    func collectionView() -> UICollectionViewMock {

        UICollectionViewMock()
    }

    func imageCarouselViewModel() -> ImageCarouselViewModelMock {

        let viewModel = ImageCarouselViewModelMock()

        viewModel.observeResultsViewModelsImp = { (observer) in

            observer(CollectionViewModel<AsyncImageViewModel>(cells: [], itemSpacing: 0.0, lineSpacing: 0.0))
        }

        return viewModel
    }

    func viewBinder() -> CollectionViewBinderMock<AsyncImageViewModel, AsyncImageCell> {

        let viewBinder = CollectionViewBinderMock<AsyncImageViewModel, AsyncImageCell>()

        viewBinder.bindCellsImp = { (collectionView) in

            { (viewModels) in

                self.boundCollectionView = collectionView
            }
        }

        return viewBinder
    }

    func imageCarouselViewIsCreated(collectionView: UICollectionViewMock, viewModel: ImageCarouselViewModelMock = ImageCarouselViewModelMock(), binder: CollectionViewBinderMock<AsyncImageViewModel, AsyncImageCell> = CollectionViewBinderMock<AsyncImageViewModel, AsyncImageCell>()) -> ImageCarouselViewImp {

        ImageCarouselViewImp(collectionView: collectionView, viewModel: viewModel, binder: binder)
    }

    func collectionViewLayoutIsHorizontalFlow(_ collectionView: UICollectionViewMock) {

        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            XCTFail("Collection view layout is not a flow layout")
            return
        }

        XCTAssertEqual(flowLayout.scrollDirection, .horizontal, "Collection view layout flow direction is not horizontal")
    }

    func collectionViewBackgroundColorIsClear(_ collectionView: UICollectionViewMock) {

        XCTAssertEqual(collectionView.backgroundColor, .clear, "Collection view background color is not clear")
    }

    func collectionView(_ collectionView: UICollectionViewMock, cellsAreBoundTo: ImageCarouselViewModelMock) {

        XCTAssertEqual(boundCollectionView, collectionView, "Collection view was not bound to view model")
    }
}