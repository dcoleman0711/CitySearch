//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class CollectionViewBinder<ViewModel> {

    func bindCells(collectionView: UICollectionView) -> ValueUpdate<[ViewModel]> {

        fatalError("CollectionViewBinder is abstract.  Subclasses must override bindCells")
    }
}

class CollectionViewBinderImp<ViewModel>: CollectionViewBinder<ViewModel> {

    override func bindCells(collectionView: UICollectionView) -> ValueUpdate<[ViewModel]> {

        { (viewModels) in }
    }
}
