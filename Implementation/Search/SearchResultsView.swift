//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchResultsView {

    var view: UIView { get }

    var model: SearchResultsModel { get }
}

class SearchResultsViewImp : SearchResultsView {

    var view: UIView { collectionView }

    var model: SearchResultsModel { viewModel.model }

    private let collectionView: UICollectionView
    private let viewModel: SearchResultsViewModel

    convenience init() {

        self.init(model: SearchResultsModelImp())
    }

    convenience init(model: SearchResultsModel) {

        let viewModel = SearchResultsViewModelImp(model: model, viewModelFactory: CitySearchResultViewModelFactoryImp())
        self.init(collectionView: UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout()), viewModel: viewModel, binder: CollectionViewBinderImp<CitySearchResultViewModel>())
    }

    init(collectionView: UICollectionView, viewModel: SearchResultsViewModel, binder: CollectionViewBinder<CitySearchResultViewModel>) {

        self.collectionView = collectionView
        self.viewModel = viewModel

        self.viewModel.observeResultsViewModels(binder.bindCells(collectionView: self.collectionView))
    }
}
