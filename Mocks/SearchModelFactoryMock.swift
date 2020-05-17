//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchModelFactoryMock : SearchModelFactory {

    var searchModelImp: (_ initialData: CitySearchResults) -> SearchModel = { (initialData) in SearchModelMock() }
    func searchModel(initialData: CitySearchResults) -> SearchModel {

        searchModelImp(initialData)
    }
}
