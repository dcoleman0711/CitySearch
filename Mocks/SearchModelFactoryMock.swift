//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchModelFactoryMock : SearchModelFactory {

    var searchModelImp: (_ searchResultsModel: SearchResultsModel, _ initialData: CitySearchResults) -> SearchModel = { (searchResultsModel, initialData) in SearchModelMock() }
    func searchModel(searchResultsModel: SearchResultsModel, initialData: CitySearchResults) -> SearchModel {

        searchModelImp(searchResultsModel, initialData)
    }
}
