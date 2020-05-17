//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol CitySearchResultViewModelFactory {

    func resultViewModel(model: CitySearchResultModel) -> CitySearchResultViewModel
}
