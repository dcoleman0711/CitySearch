//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class CitySearchResultModelFactoryMock : CitySearchResultModelFactory {

    public var resultModelImp: (_ searchResult: CitySearchResult) -> CitySearchResultModel = { (searchResult) in CitySearchResultModelMock() }
    func resultModel(searchResult: CitySearchResult) -> CitySearchResultModel {

        resultModelImp(searchResult)
    }
}
