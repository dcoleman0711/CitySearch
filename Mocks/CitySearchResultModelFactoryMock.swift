//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class CitySearchResultModelFactoryMock : CitySearchResultModelFactory {

    public var resultModelImp: (_ searchResult: CitySearchResult, _ tapCommandFactory: OpenDetailsCommandFactory) -> CitySearchResultModel = { (searchResult, tapCommandFactory) in CitySearchResultModelMock() }
    func resultModel(searchResult: CitySearchResult, tapCommandFactory: OpenDetailsCommandFactory) -> CitySearchResultModel {

        resultModelImp(searchResult, tapCommandFactory)
    }
}
