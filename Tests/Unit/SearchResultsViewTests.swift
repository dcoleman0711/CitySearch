//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import XCTest
import UIKit

class SearchResultsViewTests: XCTestCase {

    var steps: SearchResultsViewSteps!

    var given: SearchResultsViewSteps { steps }
    var when: SearchResultsViewSteps { steps }
    var then: SearchResultsViewSteps { steps }

    override func setUp() {

        super.setUp()

        steps = SearchResultsViewSteps()
    }

    override func tearDown() {

        steps = nil

        super.tearDown()
    }

    func testBindCollectionViewCells() {

        let collectionView = given.collectionView()
        let viewModel = given.searchResultsViewModel()
        let binder = given.viewBinder()

        let view = when.searchResultsViewCreated(collectionView: collectionView, viewModel: viewModel, binder: binder)

        then.collectionView(collectionView, cellsAreBoundTo: viewModel)
    }

    func testSubscribeViewModelToContentOffset() {

        let collectionView = given.collectionView()
        let viewModel = given.searchResultsViewModel()
        let contentOffset = given.contentOffset()
        let view = given.searchResultsViewCreated(collectionView: collectionView, viewModel: viewModel)

        when.collectionView(collectionView, contentOffsetUpdatesTo: contentOffset)

        then.viewModel(viewModel, isNotifiedOf: contentOffset)
    }
}

class SearchResultsViewSteps {

    private var boundCollectionView: UICollectionView?

    private var contentOffsetSentToViewModel: CGPoint?

    private var contentOffsetUpdate: [UIScrollView: CGPoint] = [:]

    func collectionView() -> UICollectionViewMock {

        UICollectionViewMock()
    }

    func contentOffset() -> CGPoint {

        CGPoint(x: 453.0, y: 0.0)
    }

    func searchResultsViewModel() -> SearchResultsViewModelMock {

        let viewModel = SearchResultsViewModelMock()

        viewModel.observeResultsViewModelsImp = { (observer) in

            observer(CollectionViewModel<CitySearchResultViewModel>(cells: [], itemSpacing: 0.0, lineSpacing: 0.0))
        }

        viewModel.subscribeToContentOffsetImp = {

            { contentOffset in self.contentOffsetSentToViewModel = contentOffset }
        }

        return viewModel
    }

    func viewBinder() -> CollectionViewBinderMock<CitySearchResultViewModel, CitySearchResultCell> {

        let viewBinder = CollectionViewBinderMock<CitySearchResultViewModel, CitySearchResultCell>()

        viewBinder.bindCellsImp = { (collectionView) in

            { (viewModels) in

                self.boundCollectionView = collectionView
            }
        }

        return viewBinder
    }

    func searchResultsViewCreated(collectionView: UICollectionViewMock, viewModel: SearchResultsViewModelMock, binder: CollectionViewBinderMock<CitySearchResultViewModel, CitySearchResultCell> = CollectionViewBinderMock<CitySearchResultViewModel, CitySearchResultCell>()) -> SearchResultsViewImp {

        SearchResultsViewImp(collectionView: collectionView, viewModel: viewModel, binder: binder)
    }

    func collectionView(_ collectionView: UICollectionViewMock, contentOffsetUpdatesTo contentOffset: CGPoint) {

        collectionView.contentOffset = contentOffset
    }

    func collectionView(_ collectionView: UICollectionViewMock, cellsAreBoundTo: SearchResultsViewModelMock) {

        XCTAssertEqual(boundCollectionView, collectionView)
    }

    func viewModel(_ viewModel: SearchResultsViewModelMock, isNotifiedOf expectedContentOffset: CGPoint) {

        XCTAssertEqual(contentOffsetSentToViewModel, expectedContentOffset, "View model was not notified of correct content offset")
    }
}