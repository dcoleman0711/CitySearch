//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol CitySearchResultModel: class {

    var titleText: String { get }
    var tapCommand: OpenDetailsCommand { get }
}

class CitySearchResultModelImp: CitySearchResultModel {

    let titleText: String
    let tapCommand: OpenDetailsCommand = OpenDetailsCommandImp()

    init(searchResult: CitySearchResult) {

        self.titleText = searchResult.name
    }
}