//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class SearchResultsViewModelMock: SearchResultsViewModel {

    var model: SearchResultsModel = SearchResultsModelMock()

    var observeResultsViewModelsImp: (_ observer: @escaping ValueUpdate<CollectionViewModel<CitySearchResultViewModel>>) -> Void = { (observer) in }
    func observeResultsViewModels(_ observer: @escaping ValueUpdate<CollectionViewModel<CitySearchResultViewModel>>) {

        observeResultsViewModelsImp(observer)
    }

    var observeContentOffsetImp: (_ observer: @escaping ValueUpdate<CGPoint>) -> Void = { observer in }
    func observeContentOffset(_ observer: @escaping ValueUpdate<CGPoint>) {

        observeContentOffsetImp(observer)
    }
}
