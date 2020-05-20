//
// Created by Daniel Coleman on 5/20/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchResultsViewModelFactoryMock: SearchResultsViewModelFactory {

    var searchResultsViewModelImp: (_ model: SearchResultsModel, _ viewModelFactory: CitySearchResultViewModelFactory) -> SearchResultsViewModel = { model, viewModelFactory in SearchResultsViewModelMock() }
    func searchResultsViewModel(model: SearchResultsModel, viewModelFactory: CitySearchResultViewModelFactory) -> SearchResultsViewModel {

        searchResultsViewModelImp(model, viewModelFactory)
    }
}
