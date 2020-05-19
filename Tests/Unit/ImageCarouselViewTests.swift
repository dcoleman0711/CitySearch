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

    func testBindCollectionViewCells() {

        let collectionView = given.collectionView()
        let viewModel = given.imageCarouselViewModel()
        let binder = given.viewBinder()

        let view = when.searchResultsViewCreated(collectionView: collectionView, viewModel: viewModel, binder: binder)

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

            observer([])
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

    func searchResultsViewCreated(collectionView: UICollectionViewMock, viewModel: ImageCarouselViewModelMock, binder: CollectionViewBinderMock<AsyncImageViewModel, AsyncImageCell>) -> ImageCarouselViewImp {

        ImageCarouselViewImp(collectionView: collectionView, viewModel: viewModel, binder: binder)
    }

    func collectionView(_ collectionView: UICollectionViewMock, cellsAreBoundTo: ImageCarouselViewModelMock) {

        XCTAssertEqual(boundCollectionView, collectionView)
    }
}