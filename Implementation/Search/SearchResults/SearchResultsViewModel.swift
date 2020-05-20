//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchResultsViewModel {

    var model: SearchResultsModel { get }

    func observeResultsViewModels(_ observer: @escaping ValueUpdate<CollectionViewModel<CitySearchResultViewModel>>)

    func observeContentOffset(_ observer: @escaping ValueUpdate<CGPoint>)

    func subscribeToContentOffset() -> ValueUpdate<CGPoint>
}

class SearchResultsViewModelImp: SearchResultsViewModel {

    let model: SearchResultsModel

    private let viewModelFactory: CitySearchResultViewModelFactory

    private let cellSize = CGSize(width: 128.0, height: 128.0)
    private let itemSpacing: CGFloat = 0.0
    private let lineSpacing: CGFloat = 16.0

    private let contentOffset = Observable<CGPoint>(.zero)

    init(model: SearchResultsModel, viewModelFactory: CitySearchResultViewModelFactory) {

        self.model = model
        self.viewModelFactory = viewModelFactory
    }

    func observeResultsViewModels(_ observer: @escaping ValueUpdate<CollectionViewModel<CitySearchResultViewModel>>) {

        self.model.observeResultsModels(mapUpdate(observer, SearchResultsViewModelImp.mapResults(self)))
    }

    func observeContentOffset(_ observer: @escaping ValueUpdate<CGPoint>) {

        contentOffset.subscribe(observer)
    }

    func subscribeToContentOffset() -> ValueUpdate<CGPoint> {

        { contentOffset in self.contentOffset.value = contentOffset }
    }

    private func mapResults(models: [CitySearchResultModel]) -> CollectionViewModel<CitySearchResultViewModel> {

        cellViewModel(cellData: self.cellData(models: models))
    }

    private func cellData(models: [CitySearchResultModel]) -> [CellData<CitySearchResultViewModel>] {

        models.map(SearchResultsViewModelImp.cellDatum(self))
    }

    private func cellDatum(model: CitySearchResultModel) -> CellData<CitySearchResultViewModel> {

        let viewModel = self.viewModelFactory.resultViewModel(model: model)
        return CellData<CitySearchResultViewModel>(viewModel: viewModel, size: cellSize, tapCommand: viewModel.tapCommand)
    }

    private func cellViewModel(cellData: [CellData<CitySearchResultViewModel>]) -> CollectionViewModel<CitySearchResultViewModel> {

        CollectionViewModel<CitySearchResultViewModel>(cells: cellData, itemSpacing: self.itemSpacing, lineSpacing: self.lineSpacing)
    }
}
