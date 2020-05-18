//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol CitySearchResultModelFactory {

    func resultModel(searchResult: CitySearchResult, tapCommandFactory: OpenDetailsCommandFactory) -> CitySearchResultModel
}

class CitySearchResultModelFactoryImp: CitySearchResultModelFactory {

    func resultModel(searchResult: CitySearchResult, tapCommandFactory: OpenDetailsCommandFactory) -> CitySearchResultModel {

        CitySearchResultModelImp(searchResult: searchResult, tapCommandFactory: tapCommandFactory)
    }
}
