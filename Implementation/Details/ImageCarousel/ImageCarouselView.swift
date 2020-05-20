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
    private let binder: CollectionViewBinder<AsyncImageViewModel, AsyncImageCell>

    convenience init(viewModel: ImageCarouselViewModel) {

        self.init(collectionView: UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()), viewModel: viewModel, binder: CollectionViewBinderImp<AsyncImageViewModel, AsyncImageCell>())
    }

    init(collectionView: UICollectionView, viewModel: ImageCarouselViewModel, binder: CollectionViewBinder<AsyncImageViewModel, AsyncImageCell>) {

        self.collectionView = collectionView
        self.viewModel = viewModel
        self.binder = binder

        setupView()
        bindViews()
    }

    private func bindViews() {

        viewModel.observeResults(binder.bindCells(collectionView: self.collectionView))
    }

    private func setupView() {

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
}