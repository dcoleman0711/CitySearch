//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol ImageCarouselView {

    var view: UIView { get }
}

class ImageCarouselViewImp: ImageCarouselView {

    var view: UIView { collectionView }

    private let collectionView: UICollectionView

    private let viewModel: ImageCarouselViewModel

    convenience init() {

        self.init(collectionView: UICollectionView(), viewModel: ImageCarouselViewModelImp(), binder: CollectionViewBinderImp<AsyncImageViewModel, AsyncImageCell>())
    }

    init(collectionView: UICollectionView, viewModel: ImageCarouselViewModel, binder: CollectionViewBinder<AsyncImageViewModel, AsyncImageCell>) {

        self.collectionView = collectionView
        self.viewModel = viewModel

        viewModel.observeResults(binder.bindCells(collectionView: self.collectionView))
    }
}