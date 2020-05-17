//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchModelFactory {

    func searchModel(searchResultsModel: SearchResultsModel, initialData: CitySearchResults) -> SearchModel
}

class SearchModelFactoryImp: SearchModelFactory {

    func searchModel(searchResultsModel: SearchResultsModel, initialData: CitySearchResults) -> SearchModel {

        fatalError("Not Implemented")
    }
}