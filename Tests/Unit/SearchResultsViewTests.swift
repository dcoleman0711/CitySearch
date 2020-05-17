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

    func testBindCollectionView() {

        let collectionView = given.collectionView()
        let viewModel = given.searchResultsViewModel()
        let binder = given.viewBinder()

        let view = when.searchResultsViewCreated(collectionView: collectionView, viewModel: viewModel, binder: binder)

        then.collectionView(collectionView, isBoundTo: viewModel)
    }
}

class SearchResultsViewSteps {

    private var boundCollectionView: UICollectionView?

    func collectionView() -> UICollectionViewMock {

        UICollectionViewMock()
    }

    func searchResultsViewModel() -> SearchResultsViewModelMock {

        let viewModel = SearchResultsViewModelMock()

        viewModel.observeResultsViewModelsImp = { (observer) in

            observer([])
        }

        return viewModel
    }

    func viewBinder() -> CollectionViewBinderMock<CitySearchResultViewModel> {

        let viewBinder = CollectionViewBinderMock<CitySearchResultViewModel>()

        viewBinder.bindCellsImp = { (collectionView) in

            { (viewModels) in

                self.boundCollectionView = collectionView
            }
        }

        return viewBinder
    }

    func searchResultsViewCreated(collectionView: UICollectionViewMock, viewModel: SearchResultsViewModelMock, binder: CollectionViewBinderMock<CitySearchResultViewModel>) -> SearchResultsViewImp {

        SearchResultsViewImp(collectionView: collectionView, viewModel: viewModel, binder: binder)
    }

    func collectionView(_ collectionView: UICollectionViewMock, isBoundTo: SearchResultsViewModelMock) {

        XCTAssertEqual(boundCollectionView, collectionView)
    }
}