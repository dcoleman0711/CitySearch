//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol SearchResultsViewModel {

    var model: SearchResultsModel { get }

    func observeResultsViewModels(_ observer: @escaping ValueUpdate<[CellData<CitySearchResultViewModel>]>)
}

class SearchResultsViewModelImp: SearchResultsViewModel {

    let model: SearchResultsModel

    private let viewModelFactory: CitySearchResultViewModelFactory

    private var resultsData: [CellData<CitySearchResultViewModel>] = [] {

        didSet { resultsObserver?(resultsData) }
    }

    private var resultsObserver: ValueUpdate<[CellData<CitySearchResultViewModel>]>?

    init(model: SearchResultsModel, viewModelFactory: CitySearchResultViewModelFactory) {

        self.model = model
        self.viewModelFactory = viewModelFactory

        self.model.observeResultsModels(SearchResultsViewModelImp.resultsModelsUpdated(self))
    }

    func observeResultsViewModels(_ observer: @escaping ValueUpdate<[CellData<CitySearchResultViewModel>]>) {

        self.resultsObserver = observer

        observer(resultsData)
    }

    private func resultsModelsUpdated(models: [CitySearchResultModel]) {

        resultsData = models.map({ CellData<CitySearchResultViewModel>(viewModel: self.viewModelFactory.resultViewModel(model: $0), size: cellSize()) })
    }

    private func cellSize() -> CGSize {

        CGSize(width: 128.0, height: 128.0)
    }
}
