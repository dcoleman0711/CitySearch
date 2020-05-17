//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchResultsModel: class {

    func setResults(_ results: CitySearchResults)
}

class SearchResultsModelImp: SearchResultsModel {

    private let modelFactory: CitySearchResultModelFactory

    private var results: [CitySearchResultModel] = []

    convenience init() {

        self.init(modelFactory: CitySearchResultModelFactoryImp())
    }

    init(modelFactory: CitySearchResultModelFactory) {

        self.modelFactory = modelFactory
    }

    func setResults(_ results: CitySearchResults) {

        self.results = results.items.map({ modelFactory.resultModel(searchResult: $0) })
    }

    func observeResultsModels(_ observer: ValueUpdate<[CitySearchResultModel]>) {

        observer(results)
    }
}