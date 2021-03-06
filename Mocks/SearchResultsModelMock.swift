//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchResultsModelMock : SearchResultsModel {

    public var observeResultsModelsImp: (_ observer: @escaping ValueUpdate<[CitySearchResultModel]>) -> Void = { (observer) in }
    func observeResultsModels(_ observer: @escaping ValueUpdate<[CitySearchResultModel]>) {

        observeResultsModelsImp(observer)
    }

    var setResultsImp: (_ results: CitySearchResults) -> Void = { (results) in }
    func setResults(_ results: CitySearchResults) {

        setResultsImp(results)
    }
}
