//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchResultsViewModel {

    func observeResultsViewModels(_ observer: @escaping ValueUpdate<[CitySearchResultViewModel]>)
}

class SearchResultsViewModelImp: SearchResultsViewModel {

    private let model: SearchResultsModel
    private let viewModelFactory: CitySearchResultViewModelFactory

    private var resultViewModels: [CitySearchResultViewModel] = [] {

        didSet { resultsObserver?(resultViewModels) }
    }

    private var resultsObserver: ValueUpdate<[CitySearchResultViewModel]>?

    init(model: SearchResultsModel, viewModelFactory: CitySearchResultViewModelFactory) {

        self.model = model
        self.viewModelFactory = viewModelFactory

        self.model.observeResultsModels(SearchResultsViewModelImp.resultsModelsUpdated(self))
    }

    func observeResultsViewModels(_ observer: @escaping ValueUpdate<[CitySearchResultViewModel]>) {

        self.resultsObserver = observer

        observer(resultViewModels)
    }

    private func resultsModelsUpdated(models: [CitySearchResultModel]) {

        resultViewModels = models.map({ self.viewModelFactory.resultViewModel(model: $0) })
    }
}
