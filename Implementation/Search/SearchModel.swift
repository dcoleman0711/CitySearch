//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchModel {
}

class SearchModelImp : SearchModel {

    init(searchResultsModel: SearchResultsModel, initialData: CitySearchResults) {

        searchResultsModel.setResults(initialData)
    }
}