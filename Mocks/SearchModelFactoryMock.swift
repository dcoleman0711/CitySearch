//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

class SearchModelFactoryMock : SearchModelFactory {

    var searchModelImp: (_ parallaxModel: ParallaxModel, _ searchResultsModel: SearchResultsModel) -> SearchModel = { (parallaxModel, searchResultsModel) in SearchModelMock() }
    func searchModel(parallaxModel: ParallaxModel, searchResultsModel: SearchResultsModel) -> SearchModel {

        searchModelImp(parallaxModel, searchResultsModel)
    }
}
