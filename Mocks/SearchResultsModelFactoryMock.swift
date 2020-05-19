//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchResultsModelFactoryMock: SearchResultsModelFactory {

    var searchResultsModelImp: (_ openDetailsCommandFactory: OpenDetailsCommandFactory) -> SearchResultsModel = { (openDetailsCommandFactory) in SearchResultsModelMock() }
    func searchResultsModel(openDetailsCommandFactory: OpenDetailsCommandFactory) -> SearchResultsModel {

        searchResultsModelImp(openDetailsCommandFactory)
    }
}
