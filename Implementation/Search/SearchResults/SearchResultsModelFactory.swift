//
// Created by Daniel Coleman on 5/18/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchResultsModelFactory {

    func searchResultsModel(openDetailsCommandFactory: OpenDetailsCommandFactory) -> SearchResultsModel
}

class SearchResultsModelFactoryImp: SearchResultsModelFactory {

    func searchResultsModel(openDetailsCommandFactory: OpenDetailsCommandFactory) -> SearchResultsModel {

        SearchResultsModelImp(openDetailsCommandFactory: openDetailsCommandFactory)
    }
}