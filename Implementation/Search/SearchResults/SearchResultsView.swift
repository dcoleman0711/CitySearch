//
// Created by Daniel Coleman on 5/16/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchResultsView {

    var view: UIView { get }

//    var model: SearchResultsModel { get }
}

class SearchResultsViewImp : SearchResultsView {

    var view: UIView { collectionView }

    private let collectionView: UICollectionView
    private let viewModel: SearchResultsViewModel

    private let contentOffsetSubscriber: NSKeyValueObservation

    convenience init(viewModel: SearchResultsViewModel) {

        self.init(collectionView: UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout()), viewModel: viewModel, binder: CollectionViewBinderImp<CitySearchResultViewModel, CitySearchResultCell>())
    }

    init(collectionView: UICollectionView, viewModel: SearchResultsViewModel, binder: CollectionViewBinder<CitySearchResultViewModel, CitySearchResultCell>) {

        self.collectionView = collectionView
        self.viewModel = viewModel

        self.viewModel.observeResultsViewModels(binder.bindCells(collectionView: self.collectionView))

        let viewModelObserver = viewModel.subscribeToContentOffset()
        self.contentOffsetSubscriber = collectionView.observe(\UICollectionView.contentOffset) { response, change in viewModelObserver(collectionView.contentOffset) }

        setupView()
    }

    private func setupView() {

        collectionView.backgroundColor = .clear

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
}
