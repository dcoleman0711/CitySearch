//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol CitySearchResultModelFactory {

    func resultModel(searchResult: CitySearchResult) -> CitySearchResultModel
}

class CitySearchResultModelFactoryImp: CitySearchResultModelFactory {

    func resultModel(searchResult: CitySearchResult) -> CitySearchResultModel {

        CitySearchResultModelImp()
    }
}
