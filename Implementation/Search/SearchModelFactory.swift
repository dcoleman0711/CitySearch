//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol SearchModelFactory {

    func searchModel(parallaxModel: ParallaxModel, searchResultsModel: SearchResultsModel) -> SearchModel
}

class SearchModelFactoryImp: SearchModelFactory {

    func searchModel(parallaxModel: ParallaxModel, searchResultsModel: SearchResultsModel) -> SearchModel {

        SearchModelImp(parallaxModel: parallaxModel, searchResultsModel: searchResultsModel)
    }
}