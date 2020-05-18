//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchResultsViewModelMock: SearchResultsViewModel {

    var model: SearchResultsModel = SearchResultsModelMock()

    var observeResultsViewModelsImp: (_ observer: @escaping ValueUpdate<[CellData<CitySearchResultViewModel>]>) -> Void = { (observer) in }
    func observeResultsViewModels(_ observer: @escaping ValueUpdate<[CellData<CitySearchResultViewModel>]>) {

        observeResultsViewModelsImp(observer)
    }
}
