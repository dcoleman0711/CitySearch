//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

struct BindingCellReuseId { static let reuseId = "BindingCell " }

protocol CellTapCommand: class { func invoke() }

struct CellData<ViewModel> {

    let viewModel: ViewModel
    let size: CGSize
    let tapCommand: CellTapCommand?
}

struct CollectionViewModel<ViewModel> {

    let cells: [CellData<ViewModel>]
    let itemSpacing: CGFloat
    let lineSpacing: CGFloat
}

class CollectionViewBinder<ViewModel, CellType: MVVMCollectionViewCell<ViewModel>> {

    func bindCells(collectionView: UICollectionView) -> ValueUpdate<CollectionViewModel<ViewModel>> {

        fatalError("CollectionViewBinder is abstract.  Subclasses must override bindCells")
    }
}

class CollectionViewBinderImp<ViewModel, CellType: MVVMCollectionViewCell<ViewModel>>: CollectionViewBinder<ViewModel, CellType> {

    override func bindCells(collectionView: UICollectionView) -> ValueUpdate<CollectionViewModel<ViewModel>> {

        collectionView.register(CellType.self, forCellWithReuseIdentifier: BindingCellReuseId.reuseId)

        let dataSource = BindingDataSource<ViewModel>()
        collectionView.dataSource = dataSource

        let delegate = BindingDelegate<ViewModel>()
        collectionView.delegate = delegate

        return { (viewModel) in

            dataSource.cellData = viewModel.cells
            delegate.viewModel = viewModel
            collectionView.reloadData()
        }
    }
}

class BindingDataSource<ViewModel>: NSObject, UICollectionViewDataSource {

    var cellData: [CellData<ViewModel>] = []

    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { cellData.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BindingCellReuseId.reuseId, for: indexPath) as? MVVMCollectionViewCell<ViewModel> else {
            fatalError("Registered cell must be a subclass of MVVMCollectionViewCell with the matching ViewModel type")
        }

        cell.viewModel = cellData[indexPath.item].viewModel

        return cell
    }
}

class BindingDelegate<ViewModel>: NSObject, UICollectionViewDelegateFlowLayout {

    var viewModel: CollectionViewModel<ViewModel>?

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let cellData = viewModel?.cells, !cellData.isEmpty else { return CGSize.zero }

        return cellData[indexPath.item].size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cellData = viewModel?.cells else { return }

        cellData[indexPath.item].tapCommand?.invoke()
    }
}