//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol CitySearchResultViewModel: class {

    var titleText: String { get }
}

class CitySearchResultViewModelImp : CitySearchResultViewModel {

    let titleText: String

    init(model: CitySearchResultModel) {

        self.titleText = model.titleText
    }
}