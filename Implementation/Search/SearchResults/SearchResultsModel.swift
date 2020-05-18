//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchResultsModel: class {

    func observeResultsModels(_ observer: @escaping ValueUpdate<[CitySearchResultModel]>)

    func setResults(_ results: CitySearchResults)
}

class SearchResultsModelImp: SearchResultsModel {

    private let modelFactory: CitySearchResultModelFactory

    private var resultModels: Observable<[CitySearchResultModel]>

    convenience init() {

        self.init(modelFactory: CitySearchResultModelFactoryImp(), resultModels: Observable<[CitySearchResultModel]>([]))
    }

    init(modelFactory: CitySearchResultModelFactory, resultModels: Observable<[CitySearchResultModel]>) {

        self.modelFactory = modelFactory

        self.resultModels = resultModels
    }

    func observeResultsModels(_ observer: @escaping ValueUpdate<[CitySearchResultModel]>) {

        resultModels.subscribe(observer, updateImmediately: true)
    }

    func setResults(_ results: CitySearchResults) {

        self.resultModels.value = results.results.map({ modelFactory.resultModel(searchResult: $0) })
    }
}