//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import UIKit

class CitySearchResultViewModelMock : CitySearchResultViewModel {

    var titleData: LabelViewModel = LabelViewModel.emptyData
    var tapCommand: OpenDetailsCommand = OpenDetailsCommandMock()

    var observeIconImageImp: (_ observer: @escaping ValueUpdate<UIImage>) -> Void = { observer in }
    func observeIconImage(_ observer: @escaping ValueUpdate<UIImage>) {

        observeIconImageImp(observer)
    }
}
