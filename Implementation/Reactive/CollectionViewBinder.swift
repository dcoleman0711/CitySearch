//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

struct BindingCellReuseId { static let reuseId = "BindingCell " }

class CollectionViewBinder<ViewModel, CellType: MVVMCollectionViewCell<ViewModel>> {

    func bindCells(collectionView: UICollectionView) -> ValueUpdate<[ViewModel]> {

        fatalError("CollectionViewBinder is abstract.  Subclasses must override bindCells")
    }
}

class CollectionViewBinderImp<ViewModel, CellType: MVVMCollectionViewCell<ViewModel>>: CollectionViewBinder<ViewModel, CellType> {

    override func bindCells(collectionView: UICollectionView) -> ValueUpdate<[ViewModel]> {

        collectionView.register(CellType.self, forCellWithReuseIdentifier: BindingCellReuseId.reuseId)

        let dataSource = BindingDataSource<ViewModel>()
        collectionView.dataSource = dataSource

        return { (viewModels) in

            dataSource.viewModels = viewModels
            collectionView.reloadData()
        }
    }
}

class BindingDataSource<ViewModel>: NSObject, UICollectionViewDataSource {

    var viewModels: [ViewModel] = []

    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModels.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BindingCellReuseId.reuseId, for: indexPath) as? MVVMCollectionViewCell<ViewModel> else {
            fatalError("Registered cell must be a subclass of MVVMCollectionViewCell with the matching ViewModel type")
        }

        cell.viewModel = viewModels[indexPath.item]

        return cell
    }
}
