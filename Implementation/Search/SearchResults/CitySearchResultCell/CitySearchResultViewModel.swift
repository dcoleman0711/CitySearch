//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CitySearchResultViewModel: class {

    var titleData: LabelViewModel { get }
    var tapCommand: OpenDetailsCommand { get }
}

class CitySearchResultViewModelImp : CitySearchResultViewModel {

    let titleData: LabelViewModel
    let tapCommand: OpenDetailsCommand

    init(model: CitySearchResultModel) {

        self.titleData = LabelViewModel(text: model.titleText, font: UIFont.systemFont(ofSize: 12.0))
        self.tapCommand = model.tapCommand
    }
}
