//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchResultsViewModelFactory {

    func searchResultsViewModel(model: SearchResultsModel, viewModelFactory: CitySearchResultViewModelFactory) -> SearchResultsViewModel
}

class SearchResultsViewModelFactoryImp: SearchResultsViewModelFactory {

    func searchResultsViewModel(model: SearchResultsModel, viewModelFactory: CitySearchResultViewModelFactory) -> SearchResultsViewModel {

        SearchResultsViewModelImp(model: model, viewModelFactory: viewModelFactory)
    }
}