//
// Created by Daniel Coleman on 5/19/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

protocol CityDetailsViewModel {

    func observeTitle(_ observer: @escaping ValueUpdate<LabelViewModel>)
}

class CityDetailsViewModelImp: CityDetailsViewModel {

    private let titleLabelFont = UIFont.systemFont(ofSize: 36.0)

    func observeTitle(_ observer: @escaping ValueUpdate<LabelViewModel>) {

        observer(LabelViewModel(text: "", font: self.titleLabelFont))
    }
}