//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class CollectionViewBinderMock<ViewModel, CellType: MVVMCollectionViewCell<ViewModel>>: CollectionViewBinder<ViewModel, CellType> {

    var bindCellsImp: (_ collectionView: UICollectionView) -> ValueUpdate<CollectionViewModel<ViewModel>> = { (collectionView) in { viewModel in } }
    override func bindCells(collectionView: UICollectionView) -> ValueUpdate<CollectionViewModel<ViewModel>> {

        bindCellsImp(collectionView)
    }
}
