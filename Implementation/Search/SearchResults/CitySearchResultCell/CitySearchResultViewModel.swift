//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CitySearchResultViewModel: class {

    var titleData: LabelViewModel { get }
}

class CitySearchResultViewModelImp : CitySearchResultViewModel {

    let titleData: LabelViewModel

    init(model: CitySearchResultModel) {

        self.titleData = LabelViewModel(text: model.titleText, font: UIFont())
    }
}